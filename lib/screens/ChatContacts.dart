import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static const String id = "chat_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF00E676),
        title: Text('Saviours', style: TextStyle(color: Colors.white)),
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