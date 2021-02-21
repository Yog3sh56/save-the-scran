import 'package:flutter/material.dart';


class CommunityMarketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF00E676),
        title: Text("Community Market", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        // child: ElevatedButton(
        //   onPressed: () {
        //     // Navigate back to the first screen by popping the current route
        //     // off the stack.
        //     Navigator.pop(context);
        //   },
        //   child: Text('Go back!'),
        // ),
      ),
    );
  }
}