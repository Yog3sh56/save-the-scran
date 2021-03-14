import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/models/Item.dart';
import 'package:save_the_scran/screens/LoginScreen.dart';
import 'package:save_the_scran/screens/ProfileScreen.dart';
import 'package:save_the_scran/screens/TakePictureScreen.dart';
import 'package:save_the_scran/widgets/FoodWidget.dart';

class FridgeScreen extends StatefulWidget {
  static const String id = "fridge_screen";
  @override
  State<StatefulWidget> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;

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
    Item i = Item(
        (_auth.currentUser == null) ? "" : _auth.currentUser.uid, "asyncFood");
    _firestore.collection("items").add({
      "ownerid": i.ownerid,
      "name": i.name,
      "buyDate": i.buyDate,
      "expiryDate": i.expiry,
      "inCommunity": i.inCommunity
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.3),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('My Fridge', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
              icon: Icon(Icons.person,color: Colors.black,),
              onPressed: () {
                if (_auth.currentUser == null) {
                  Navigator.pushNamed(context, LoginScreen.id);
                } else {
                  Navigator.pushNamed(context, ProfileScreen.id);
                }
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, TakePictureScreen.id);
          //addItem();
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFFF4081),
      ),
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
                  Item i = Item(item['ownerid'], item['name'],
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
