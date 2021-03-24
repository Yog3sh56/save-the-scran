import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../chat/ChatUserModel.dart';
import 'ConversationList.dart';

class ChatContacts extends StatefulWidget {

  static const String id = "chat_contacts";
  @override
  _ChatContactsState createState() => _ChatContactsState();
}




class _ChatContactsState extends State<ChatContacts> {
  final _auth = FirebaseAuth.instance;
  final _firebase = FirebaseFirestore.instance;
  List<ChatUsers> chatUsers=[];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
       body:SingleChildScrollView(
                child: Column(
              children: <Widget>[
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Saviours",
                          style:
                              TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                _auth.currentUser != null?
                StreamBuilder(
                  stream:_firebase
                  .collection("messages")
                  .orderBy("createdAt",descending: true)
                  .where("twoIds",arrayContains: _auth.currentUser.uid)
                  .snapshots(),
                        
                  builder: (context,snapshot){
                    //initiate conversation list
                    List<ConversationList> conversations=[];
                    if (snapshot.hasData){
                      //initiate array so we don't repeat conversations
                      List<String> alreadyProcessed = [_auth.currentUser?.uid];
                      
                      //snapshot docs
                      final snapshotDocs = snapshot.data.docs;
                      

                      for (var item in snapshotDocs){
                        

                        //parse in the other user Id, has to be converted to string
                        List<String> ids=[];
                        for (var val in item['twoIds']){
                          ids.add(val.toString());
                        } 
                        ids.remove(_auth.currentUser?.uid);


                        //if message chain from user has not been added yet
                        if (!alreadyProcessed.contains(ids[0])){
                          print(item['itemName']);

                          //create Conversation Card
                          var c=ConversationList(
                            name: ids[0],
                            messageText: item['text'],
                            otherPerson: ids[0],
                            time: item['createdAt'].toDate().toString(),
                            itemName: item['itemName'],
                          );
                          //add card and add processesd id
                          conversations.add(c);
                          alreadyProcessed.add(ids[0]);
                          
                        }
                      }
                      
                      return ListView(
                        shrinkWrap: true,
                        children: conversations
                      );
                    } else{
                    return Text("no messages");
                    }
                    
                  })
                  :Text("Please login to send messages")
                ,

              ],
            ),
       ),
    );
      
    
  }
}
