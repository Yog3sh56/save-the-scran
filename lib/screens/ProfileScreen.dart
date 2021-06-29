import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_the_scran/models/Item.dart';
import 'package:save_the_scran/screens/ScranWelcomeScreen.dart';
import 'package:save_the_scran/utils/StorageHelper.dart';
import 'package:save_the_scran/widgets/FoodWidgetProfile.dart';
import 'package:save_the_scran/widgets/ProfilePicture.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = "profile_screen";

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storageHelper = StorageHelper();
  var downloadUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('My Profile', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.greenAccent[200], shape: BoxShape.circle),
                child: ProfilePicture(
                  onTap: () async {
                    final imagePath = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    File image = File(imagePath.path);
                    // ignore: await_only_futures
                    await _storageHelper.uploadFile(image);
                    downloadUrl = await _storageHelper.getProfileImage();
                  },
                  downloadUrl: this.downloadUrl == null
                      ? getProfilePicture()
                      : this.downloadUrl,
                ) // This trailing comma makes auto-formatting nicer for build methods.
                ),
            Text(_auth.currentUser.email),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pushNamed(context, ScranWelcomeScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Text(
              "Items in Community",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder(
                  //the stream provides a snapshot, to pass onto the builder
                  stream: _firestore
                      .collection("items")
                      .where("inCommunity", isEqualTo: true)
                      .where("ownerid",
                          isEqualTo: (_auth.currentUser == null)
                              ? ""
                              : _auth.currentUser.uid)
                      .snapshots(),
                  //the builder takes in the stream
                  builder: (context, snapshot) {
                    List<Widget> itemText = [];
                    //make sure snapshot has data
                    if (snapshot.hasData) {
                      //declare vars
                      final snapshotDocs = snapshot.data.docs;
                      List<Item> itemsList = [];

                      //parse data
                      for (var item in snapshotDocs) {
                        Item i = Item(
                            item['ownerid'], item['name'], item['imageUrl'],
                            buyDate: item['buyDate'].toDate(),
                            expiry: item['expiryDate'].toDate(),
                            inCommunity: true);
                        itemsList.add(i);
                        final fw = FoodWidgetProfile(
                          item: i,
                          id: item.id,
                        );
                        itemText.add(fw);
                        //itemText.add(Text(item['name']));
                      }
                      if (itemsList.length == 0) {
                        return Text(
                            "no items in market, you can add them from your fridge");
                      }
                      return ListView(
                        padding: EdgeInsets.all(5),
                        children: itemText,
                      );
                    } else {
                      return Text("no items");
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  String getProfilePicture() {
    _storageHelper.getProfileImage().then((String value) {
      setState(() {
        this.downloadUrl = value;
      });
    });
    return null;
  }
}
