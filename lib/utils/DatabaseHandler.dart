import 'package:flutter/widgets.dart';
import 'package:save_the_scran/models/Item.dart';

class DbHandler {
  static pushtoMarket(
      _auth, _firestore, itemName, imageUrl, _expiry, context) async {
    if (_auth.currentUser == null) return;
    if (itemName.isEmpty) return;

    // Changed it to account for imageUrl -- Yogi
    _firestore.collection("items").add({
      "ownerid": _auth.currentUser.uid,
      "name": itemName.isEmpty ? "no name" : itemName,
      "imageUrl": imageUrl?.isEmpty == null ? "No image" : imageUrl,
      "buyDate": DateTime.now(),
      "expiryDate": _expiry,
      "inCommunity": false,
    });
    Navigator.popUntil(context, (route) => route.isFirst);
  }
    //basic example of how objects are fetched
  void getUserItems(_firestore,_auth) async {
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
  void itemStream(_firestore,_auth) async {
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
  
}
