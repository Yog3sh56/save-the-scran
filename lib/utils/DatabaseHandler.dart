import 'package:flutter/widgets.dart';

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
}
