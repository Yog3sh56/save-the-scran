import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:save_the_scran/models/Item.dart';
import 'package:save_the_scran/screens/RegistrationScreen.dart';
import 'package:save_the_scran/utils/LocationWrap.dart';
import 'package:save_the_scran/widgets/FoodWidgetMarket.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  List<dynamic> closeUsers;
  User loggedInUser;




  //image file
  final List<String> imageSlides = [
    "images/slide0.jpg",
    "images/slide1.jpg",
    "images/slide2.jpg",
    "images/slide3.jpg"
  ];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent[200],

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

          //     flexibleSpace: ClipRRect(
          //       borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),bottomLeft: Radius.circular(15)),
          //       child:Container(
          //         decoration: BoxDecoration(
          //           image: DecorationImage(
          //             image: AssetImage("images/0.jpg"),
          //             fit: BoxFit.cover,
          //             colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.5),BlendMode.dstIn)
          //
          //           )
          //         )
          //     ),
          // ),


          title:
                    Text('Community Market', style: TextStyle(color: Colors.black)),
                actions: [
                  IconButton(
                      icon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if (_auth.currentUser == null) {
                          Navigator.pushNamed(context, LoginScreen.id);
                        } else {
                          Navigator.pushNamed(context, ProfileScreen.id);
                        }
                      })
                ],
        ),
        body:
            FutureBuilder(
                    future: getClosest(_auth, 100),
                    builder: (context, snapshotOuter) {
                      if (snapshotOuter.connectionState == ConnectionState.done &&
                          snapshotOuter.hasData) {
                        return Center(
                          child: StreamBuilder(
                            //the stream provides a snapshot, to pass onto the builder
                              stream: _firestore
                                  .collection("items")
                                  .where("ownerid", whereIn: snapshotOuter.data)
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
                                    // if (_auth.currentUser != null){
                                    //   // if (item['ownerid'] == _auth.currentUser.uid) {
                                    //   //   continue;
                                    //   // }
                                    //
                                    // }

                                    Item i = Item(
                                        item['ownerid'], item['name'], item['imageUrl'],
                                        buyDate: item['buyDate'].toDate(),
                                        expiry: item['expiryDate'].toDate(),
                                        inCommunity: true);

                                    itemsList.add(i);

                                    final fw = FoodWidgetMarket(
                                      item: i,
                                      id: item.id,
                                      ownerid: item['ownerid'],
                                    );
                                    itemText.add(fw);

                                    //itemText.add(Text(item['name']));
                                  }
                                  return ListView(children: itemText);
                                }
                                return ListView(children: itemText);
                              }),
                        );
                      } else {
                        if (snapshotOuter.connectionState == ConnectionState.done) {
                          return Center(child: Text("no items"));
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })

      ),
    );

  }
}



double getDistance(dynamic userLocation, GeoPoint loc) {
  double dx = loc.longitude - userLocation.longitude;
  double dy = loc.longitude - userLocation.latitude;
  return sqrt(dx * dx + dy * dy);
}

Future<List<dynamic>> getClosest(var _auth, double limit) async {
  //LocationData userLocation = await LocationWrap.getLocation();

  var uLoc;
  List<dynamic> buff = [];
  List<dynamic> ret = [];
  var uid = _auth.currentUser.uid;
  var instances =
      await FirebaseFirestore.instance.collection("locations").get();

  for (var entry in instances.docs) {
    var data = entry.data();
    if (data["uid"] == uid)
      uLoc = data["location"];
    else
      buff.add(data);
    //var loc = data["location"];
    //double dist = getDistance(userLocation, loc);

    //if (dist < limit) ret.add(data["uid"]);
  }
  if (uLoc == null) {
    uLoc = await LocationWrap.getLocation();
    insertLocationData(uid, uLoc);
  }

  if (buff.isEmpty) return null;
  //userLocation = uLoc == null ? await LocationWrap.getLocation() : uLoc;
  for (var entry in buff) {
    var loc = entry["location"];
    var dist = getDistance(uLoc, loc as GeoPoint);
    if (dist < limit) ret.add(entry["uid"]);
  }

  if (ret.isEmpty) return null;
  return ret;
}
