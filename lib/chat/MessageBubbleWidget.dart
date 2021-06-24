import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.myId);
  // MessageBubble(this.message, this.isMe, {key}) : super(key: key);

  final dynamic message;
  final String myId;
  bool isMe = false;

  @override
  Widget build(BuildContext context) {
    if (message['senderId'] == myId) isMe = true;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe ? Color(0xFFff79af) : Colors.grey,
            boxShadow: [
              BoxShadow(
                  color: isMe ? Colors.black.withOpacity(0.2) : Colors.grey,
                  offset: Offset.fromDirection(1, 2))
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.6,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message['text'],
            style: TextStyle(
              color: Colors.black,
              // color: isMe
              //     ? Colors.black
              //     : Theme.of(context).accentTextTheme.headline1.color
            ),
          ),
        ),
      ],
    );
  }
}
