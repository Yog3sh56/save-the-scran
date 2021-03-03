import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/screens/LoginScreen.dart';
import 'package:save_the_scran/screens/ProfileScreen.dart';
import 'package:save_the_scran/screens/RegistrationScreen.dart';
import 'package:save_the_scran/screens/TakePictureScreen.dart';

class FridgeScreen extends StatefulWidget {

  static const String id = "fridge_screen";
  @override
  State<StatefulWidget> createState() => _FridgeScreenState();
  
}

class _FridgeScreenState extends State<FridgeScreen>{

    final _auth = FirebaseAuth.instance;
    User loggedInUser;

  @override
  Widget build(BuildContext context) {

    


    return Scaffold(
      backgroundColor: Colors.blueAccent[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF00E676),
        title: Text('My Fridge', style: TextStyle(color: Colors.white)),
        actions: [IconButton(icon: Icon(Icons.person), onPressed:(){ 
          if (loggedInUser == null){
            Navigator.pushNamed(context,LoginScreen.id);
          }
          else{Navigator.pushNamed(context,ProfileScreen.id);}

          })],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, TakePictureScreen.id);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFFF4081),
      ),
      body: Center(
          // child: ElevatedButton(
          //   child: Text('Community Market'),
          //   onPressed: () {
          //     // Navigate to the second screen using a named route.
          //     Navigator.pushNamed(context, '/market');
          //   },
          // ),
          ),
    );
  }
}
