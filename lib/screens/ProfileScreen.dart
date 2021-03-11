import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/models/Item.dart';
import 'package:save_the_scran/widgets/FoodWidgetProfile.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = "profile_screen";

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  void itemStream() async {
    //_firestore.collection("items").where("ownerid",isEqualTo: _auth.currentUser.uid).snapshots()
    await for (var snapshot in _firestore
        .collection("items")
        .where("ownerid",
            isEqualTo: (_auth.currentUser == null) ? "" : _auth.currentUser.uid)
        .where("inCommunity", isEqualTo: true)
        .snapshots()) {
      for (var i in snapshot.docs) {
        print(i.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00E676),
        title: Text("Your Profile", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.lightBlue, shape: BoxShape.circle),
                child: Icon(
                  Icons.person,
                  size: 200,
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
                    Navigator.pop(context);
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
            Expanded(
                          child: StreamBuilder(
                  //the stream provides a snapshot, to pass onto the builder
                  stream: _firestore
                      .collection("items")
                      .where("inCommunity", isEqualTo: true)
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
                        Item i = Item(item['ownerid'], item['name'],
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
                      return ListView(
                        children: itemText,
                      );
                    }
                    return ListView(children: itemText);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
