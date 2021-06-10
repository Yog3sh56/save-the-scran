import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

// Class to help store the profile picture and to retrieve it.

class StorageHelper {
  firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instanceFor(
          bucket: "gs://savethescran.appspot.com/");
  final _auth = FirebaseAuth.instance;

  void uploadFile(File file) async {
    var userId = _auth.currentUser.uid;

    firebase_storage.UploadTask task =
        _storage.ref().child("user/profile/$userId").putFile(file);

    try {
      firebase_storage.TaskSnapshot snapshot = await task;
      print('Upload ${snapshot.bytesTransferred} bytes');
    } on firebase_core.FirebaseException catch (e) {
      print(task.snapshot);
    }
    return null;
  }

  Future<String> getProfileImage() async {
    final uid = _auth.currentUser.uid;
    try {
      final downloadUrl =
          await _storage.ref().child("user/profile/$uid").getDownloadURL();
      
      print("download url from getProfileImage() $downloadUrl");
      return downloadUrl;
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    return null;
  }
}
