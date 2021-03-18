import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:save_the_scran/chat/MessageBubbleWidget.dart';

class Messages extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data.docs;
        if (user.uid == null) {
          return Center(child: CircularProgressIndicator(),);

        }
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(chatDocs[index]['text'], chatDocs[index]['userId']==user.uid),
          // itemBuilder: (ctx, index) => MessageBubble(chatDocs[index]['text'], chatDocs[index]['userId']==user.uid), key: ValueKey(chatDocs.documentID),
        );
      },
    );
  }
}
