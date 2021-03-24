import 'package:flutter/material.dart';
import 'package:save_the_scran/chat/MessagesWidget.dart';
import 'package:save_the_scran/chat/NewMessageWidget.dart';

class ChatScreen extends StatelessWidget {
  static const String id = "chat_screen";
  final otherPerson;
  final itemName;

  const ChatScreen({Key key, this.otherPerson,this.itemName}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0.3),
        title: Text('Saviours', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(otherPerson:otherPerson),
            ),
            NewMessage(otherPerson: otherPerson,itemName: itemName,),
          ],
        ),
      ),
    );
  }
}