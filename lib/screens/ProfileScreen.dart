import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget{

  static const String id = "profile_screen";
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Color(0xFF00E676),
        title: Text("Community Market", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children:[
          Text("profile sCreen"),
          MaterialButton(onPressed:(){
            if (_auth.currentUser != null){
              _auth.signOut();
            }
          } ,),
          ]
      ),
    );
  }
}
 