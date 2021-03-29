import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/models/Item.dart';
import 'package:save_the_scran/widgets/FoodWidgetMarket.dart';

import 'LoginScreen.dart';
import 'ProfileScreen.dart';

class CommunityMarketScreen extends StatefulWidget {
  static const String id = "market_screen";
  @override
  State<StatefulWidget> createState() => _CommunityMarketScreenState();
}

class _CommunityMarketScreenState extends State<CommunityMarketScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;

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
        title: Text('Community Market', style: TextStyle(color: Colors.black)),
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
      body: Center(
        child: StreamBuilder(
            //the stream provides a snapshot, to pass onto the builder
            stream: _firestore
                .collection("items")
                .where("inCommunity", isEqualTo: true)
                .orderBy("expiryDate")
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
                  if (_auth.currentUser != null){
                    if (item['ownerid'] == _auth.currentUser.uid){
                      continue;
                    }
                  }
                  
                  Item i = Item(item['ownerid'], item['name'],
                      buyDate: item['buyDate'].toDate(),
                      expiry: item['expiryDate'].toDate(),
                      inCommunity: true);
                  
                  itemsList.add(i);

                  final fw = FoodWidgetMarket(
                    item: i,
                    id: item.id,
                    ownerid:item['ownerid'],
                    
                  );
                  itemText.add(fw);
                  //itemText.add(Text(item['name']));
                }
                return ListView(children: itemText);
              }
              return ListView(children: itemText);
            }),
      ),
    );
  }
}
