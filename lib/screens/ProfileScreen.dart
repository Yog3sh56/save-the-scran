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
        title: Text("Your Profile", style: TextStyle(color: Colors.white)),
      ),
      
      body: Center(
          child: Column(
            children:[
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color:Colors.lightBlue,shape: BoxShape.circle),
                child:Icon(
                  Icons.person,
                  size: 200,
                ) // This trailing comma makes auto-formatting nicer for build methods.
              ),
              Text(_auth.currentUser.email),
              Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pop(context);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            ]
        ),
      ),
    );
  }
}
 