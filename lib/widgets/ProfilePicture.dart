import 'package:flutter/material.dart';
import 'package:save_the_scran/utils/StorageHelper.dart';

class ProfilePicture extends StatelessWidget {
  final String downloadUrl;
  final _storageHelper = StorageHelper();

  final Function onTap;

  ProfilePicture({this.onTap, this.downloadUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: downloadUrl == null
          ? Icon(Icons.person)
          : CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage(downloadUrl)),
    );
  }
}
