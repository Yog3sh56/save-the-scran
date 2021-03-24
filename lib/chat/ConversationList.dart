import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/chat/ChatScreen.dart';

class ConversationList extends StatefulWidget {

  static const String id = "chat_contacts";

  String name;
  String messageText;
  final otherPerson;
  String time;
  bool isMessageRead=true;
  String itemName;
  ConversationList(
      {@required this.name,
      @required this.messageText,
      @required this.time,
      @required this.otherPerson,
      @required this.itemName});
  @override
  _ConversationListState createState() => _ConversationListState(otherPerson);
}

//,@required this.imageUrl

class _ConversationListState extends State<ConversationList> {
  final otherPerson;
  final _firestore = FirebaseFirestore.instance;
  final _auth  = FirebaseAuth.instance;

  _ConversationListState(this.otherPerson);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background: Padding(
            padding: EdgeInsets.fromLTRB(5, 8, 0, 8),
            child: Container(
                padding: EdgeInsets.all(20),
                alignment: AlignmentDirectional.centerStart,
                child: Icon(Icons.delete),
                color: Colors.red)),
        secondaryBackground: Padding(
            padding: EdgeInsets.fromLTRB(5, 8, 0, 8),
            child: Container(
                padding: EdgeInsets.all(20),
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(Icons.delete),
                color: Colors.red)),
        key: UniqueKey(),
        onDismissed: (DismissDirection direction) async {
          List<String> vals = [_auth.currentUser.uid,otherPerson.toString()];
          vals.sort();

          _firestore.collection("messages")
          .where("twoIds",isEqualTo: vals).
          get().then((value) => value.docs.forEach((element) {
            print(element.id);
            _firestore.collection("messages").doc(element.id).delete();
          }));
        
          //_firestore.collection("items").doc(id).delete();
        },
        child:GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatScreen(otherPerson: otherPerson,itemName: widget.itemName,);
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
  ));
  }
}
