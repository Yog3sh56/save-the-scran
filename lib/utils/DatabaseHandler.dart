import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:save_the_scran/utils/LocationWrap.dart';

import '../main.dart';

class DbHandler {
  static pushtoMarket(
      _auth, _firestore, itemName, imageUrl, _expiry, context) async {
    if (_auth.currentUser == null) return;
    if (itemName.isEmpty) return;
    LocationData loc = await LocationWrap.getCachedLocation;
    GeoPoint gp = GeoPoint(loc.latitude,loc.longitude);

    // Changed it to account for imageUrl -- Yogi
    _firestore.collection("items").add({
      "ownerid": _auth.currentUser.uid,
      "name": itemName.isEmpty ? "no name" : itemName,
      "imageUrl": imageUrl?.isEmpty == null ? "No image" : imageUrl,
      "buyDate": DateTime.now(),
      "expiryDate": _expiry,
      "inCommunity": false,
      "location": gp, 
    });
    Navigator.popUntil(context, (route) => route.isFirst);
    // Navigator.pushNamed(context,MyApp.id);

  }
}
