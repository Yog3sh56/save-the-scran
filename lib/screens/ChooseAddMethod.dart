import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:save_the_scran/screens/AddItemScreen.dart';

import 'ProfileScreen.dart';
import 'ScranWelcomeScreen.dart';
import 'TakePictureScreen.dart';

class ChooseAddMethod extends StatelessWidget {
  static const String id = "choose_add";
  final _auth = FirebaseAuth.instance;

  ChooseAddMethod({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xFFc2075e),
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
        ),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                child: Container(
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "Smart-Scan  ",
                      style: TextStyle(fontSize: 25),
                    ),
                    Icon(
                      Icons.qr_code_scanner,
                      size: 30,
                    ),
                  ]),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ Color(0xFFc2075e),  Color(0xFFc2075e)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, TakePictureScreen.id);
                },
              ),
            ),
            Expanded(
              child: GestureDetector(
                child: Container(
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "Enter Manually ",
                      style: TextStyle(fontSize: 25),
                    ),
                    Icon(
                      Icons.sort_by_alpha,
                      size: 30,
                    ),
                  ]),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.greenAccent[200], Colors.greenAccent[200]],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, AddItemScreen.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
