import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final otherPerson;
  final itemName;

  const NewMessage({Key key, this.otherPerson, this.itemName})
      : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final user = FirebaseAuth.instance.currentUser;

  final _controller = new TextEditingController();
  var _enteredMessage = '';
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    List<String> hashes = [user.uid, widget.otherPerson.toString()];
    hashes.sort();
    print(widget.itemName);

    FirebaseFirestore.instance.collection('messages').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'senderId': user.uid,
      'receiverId': widget.otherPerson,
      'twoIds': hashes,
      'itemName': widget.itemName
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          margin: EdgeInsets.all(8),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      //labelText: 'Send a message...'
                      border: InputBorder.none,
                      hintText: "Type your message"),
                  onChanged: (value) {
                    setState(() {
                      _enteredMessage = value;
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
