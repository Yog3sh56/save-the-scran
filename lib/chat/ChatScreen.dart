import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/chat/MessagesWidget.dart';
import 'package:save_the_scran/chat/NewMessageWidget.dart';

class ChatScreen extends StatelessWidget {
  static const String id = "chat_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF00E676),
        title: Text('Saviours', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}