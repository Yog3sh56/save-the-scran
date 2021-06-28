import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:save_the_scran/models/Item.dart';
import 'package:save_the_scran/screens/RegistrationScreen.dart';
import 'package:save_the_scran/utils/LocationWrap.dart';
import 'package:save_the_scran/widgets/FoodWidgetMarket.dart';

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
  double maxDist = LocationWrap().getLastDistance();

  @override
  void initState() {
    super.initState();
  }

  void reloadMainWidget() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(maxDist);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.greenAccent[200],

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              centerTitle: true,
              // backgroundColor: Colors.white,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(15)),
                  gradient: LinearGradient(
                    colors: [Colors.greenAccent[200], Colors.greenAccent[200]],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
              ),
              title: Text('Community Market',
                  style: TextStyle(color: Colors.black)),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.filter_list_sharp,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: Text("Maximum Distance"),
                              children: [
                                StatefulBuilder(builder: (context, setState) {
                                  return Column(children: [
                                    Slider(
                                        min: 1,
                                        max: 4000,
                                        // value: 20,
                                        value: maxDist,
                                        divisions: 10,
                                        label:
                                            maxDist.toInt().toString() + " km",
                                        onChanged: (changed) => setState(() {
                                              maxDist = changed;
                                              LocationWrap()
                                                  .setLastDistance(changed);
                                            })),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        reloadMainWidget();
                                      },
                                      child: Text("Apply"),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.greenAccent[200])),
                                    ),
                                  ]);
                                }),
                              ],
                            );
                          });
                    })
              ],
            ),
            body: FutureBuilder(
                future: getUserLocation(),
                builder: (context, snapshotOuter) {
                  if (snapshotOuter.connectionState == ConnectionState.done &&
                      snapshotOuter.hasData) {
                    return Center(
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
                                item = item.data();

                                var itemLocation = item["location"];
                                var dist = getDistance(
                                    snapshotOuter.data, itemLocation);

                                if (dist < maxDist &&
                                    item["ownerid"] != _auth.currentUser.uid) {
                                  Item i = Item(item['ownerid'], item['name'],
                                      item['imageUrl'],
                                      buyDate: item['buyDate'].toDate(),
                                      expiry: item['expiryDate'].toDate(),
                                      inCommunity: true);
                                  itemsList.add(i);
                                  final fw = FoodWidgetMarket(
                                    item: i,
                                    ownerid: item['ownerid'],
                                  );
                                  itemText.add(fw);
                                  //itemText.add(Text(item['name']));
                                }
                              }
                              if (itemsList.isEmpty){
                                return Container(
                                  width: 250,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    image: new DecorationImage(
                                        colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.4), BlendMode.dstATop),
                                        image: AssetImage('images/watermelon.png'),
                                        fit: BoxFit.contain),
                                  ),
                                  child: const Align(
                                      alignment: FractionalOffset(0.5, -0.2),
                                      child: Text("There are no items near you.", style: TextStyle(fontSize: 15),)),
                                );
                              } else {
                                return ListView(children: itemText);
                              }

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
                })));
  }
}

double getDistance(dynamic userLocation, GeoPoint loc) {
  double dist = Geolocator.distanceBetween(loc.latitude, loc.longitude,
      userLocation.latitude, userLocation.longitude);
  return dist;
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
  }
  if (uLoc == null) {
    uLoc = await LocationWrap.getLocation();
    insertLocationData(uid, uLoc);
  }

  if (buff.isEmpty) return null;

  // if (buff.isEmpty)
  //   userLocation = uLoc == null ? await LocationWrap.getLocation() : uLoc;
  for (var entry in buff) {
    var loc = entry["location"];
    var dist = getDistance(uLoc, loc as GeoPoint);
    if (dist < limit) ret.add(entry["uid"]);
  }

  if (ret.isEmpty) return null;
  return ret;
}

Future<LocationData> getUserLocation() async {
  var inst = LocationWrap();
  var m = await inst.staticUserLocation();
  if (m == null) {
    LocationData uLoc = await LocationWrap.getLocation();
    return uLoc;
  } else {
    return m;
  }
}
