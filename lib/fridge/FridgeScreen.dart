import 'package:flutter/material.dart';
import 'package:save_the_scran/camera/TakePictureScreen.dart';

class FridgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF00E676),
        title: Text('My Fridge', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/camera');
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
