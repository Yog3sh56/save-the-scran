import 'package:flutter/material.dart';
import 'package:save_the_scran/chat/ChatScreen.dart';

class ConversationList extends StatefulWidget {

  static const String id = "chat_contacts";

  String name;
  String messageText;
  final otherPerson;
  // String imageUrl;
  String time;
  bool isMessageRead;
  String itemName;
  ConversationList(
      {@required this.name,
      @required this.messageText,
      @required this.time,
      @required this.otherPerson,
      @required this.isMessageRead,
      @required this.itemName});
  @override
  _ConversationListState createState() => _ConversationListState(otherPerson);
}

//,@required this.imageUrl

class _ConversationListState extends State<ConversationList> {
  final otherPerson;

  _ConversationListState(this.otherPerson);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatScreen(otherPerson: otherPerson);
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    // backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.itemName==null?"":widget.itemName,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(

                            widget.messageText==null?"":widget.messageText,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: widget.isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time==null?"":
              widget.time.toString().split(" ")[0],
              
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.isMessageRead
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
