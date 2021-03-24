import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:save_the_scran/chat/MessageBubbleWidget.dart';

class Messages extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final otherPerson;


  Messages({Key key, this.otherPerson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> twoIds = [_auth.currentUser.uid,otherPerson.toString()];
    twoIds.sort();
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where("twoIds",isEqualTo: twoIds)
          
          .orderBy('createdAt', descending: true)
          
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (chatSnapshot.hasData){
        final chatDocs = chatSnapshot.data.docs;
        
        if (_auth.currentUser.uid == null) {
          return Center(child: CircularProgressIndicator(),);
        }
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(chatDocs[index],_auth.currentUser.uid),
          // itemBuilder: (ctx, index) => MessageBubble(chatDocs[index]['text'], chatDocs[index]['userId']==user.uid), key: ValueKey(chatDocs.documentID),
        );
        }else{
          return Text("no data");
        }
      },
    );
  }
}
