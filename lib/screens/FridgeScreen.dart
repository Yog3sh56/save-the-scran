import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:save_the_scran/models/Item.dart';
import 'package:save_the_scran/screens/ProfileScreen.dart';
import 'package:save_the_scran/screens/ScranWelcomeScreen.dart';
import 'package:save_the_scran/screens/TakePictureScreen.dart';
import 'package:save_the_scran/widgets/FoodWidget.dart';
import 'dart:async';

class FridgeScreen extends StatefulWidget {
  static const String id = "fridge_screen";

  @override
  State<StatefulWidget> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser == null){
      // it will navigate to Welcome page as soon as this state is built
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(ScranWelcomeScreen.id);
      });
    }
  }
  //basic example of how objects are fetched
  void getUserItems() async {
    final userItems = await _firestore
        .collection("items")
        .where("ownerid",
        isEqualTo: (_auth.currentUser == null) ? "" : _auth.currentUser.uid)
        .get();
    for (var item in userItems.docs) {
      print(item.data());
    }
  }

  //example of how streams are handled
  void itemStream() async {
    //_firestore.collection("items").where("ownerid",isEqualTo: _auth.currentUser.uid).snapshots()
    await for (var snapshot in _firestore
        .collection("items")
        .where("ownerid",
        isEqualTo: (_auth.currentUser == null) ? "" : _auth.currentUser.uid)
        .snapshots()) {
      for (var i in snapshot.docs) {
        print(i.data());
      }
    }
  }

  //add item function
  void addItem() {
    Item i = Item((_auth.currentUser == null) ? "" : _auth.currentUser.uid,
        "asyncFood", "imageUrl");
    _firestore.collection("items").add({
      "ownerid": i.ownerid,
      "name": i.name,
      "imageUrl": i.imageUrl,
      "buyDate": i.buyDate,
      "expiryDate": i.expiry,
      "inCommunity": i.inCommunity
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        centerTitle: true,
        // backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            gradient: LinearGradient(
              colors: [Colors.greenAccent[200], Colors.greenAccent[200]],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),

        title: Text('My Fridge', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              onPressed: () {
                if (_auth.currentUser == null) {
                  Navigator.pushNamed(context, ScranWelcomeScreen.id);
                } else {
                  Navigator.pushNamed(context, ProfileScreen.id);
                }
              })
        ],

        elevation: 4,
      ),
      /*
      floatingActionButton: FloatingActionButton(
        
        onPressed: () {
          Navigator.pushNamed(context, TakePictureScreen.id);
          //addItem();
        },
        child: Icon(Icons.add),
        backgroundColor:Colors.greenAccent[200],
      ),
      */
      body: Center(
        child: StreamBuilder(
          //the stream provides a snapshot, to pass onto the builder
            stream: _firestore
                .collection("items")
                .where("ownerid",
                isEqualTo: (_auth.currentUser == null)
                    ? ""
                    : _auth.currentUser.uid)
                .where("inCommunity", isEqualTo: false)
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
                  Item i = Item(item['ownerid'], item['name'], item['imageUrl'],
                      buyDate: item['buyDate'].toDate(),
                      expiry: item['expiryDate'].toDate(),
                      inCommunity: item['inCommunity']);
                  itemsList.add(i);
                  String objectId = item.id;
                  final fw = FoodWidget(item: i, id: objectId);
                  itemText.add(fw);
                }
              }
              return ListView(children: itemText);
            }),
      ),
    );
  }
}
