import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:save_the_scran/models/ChatUserModel.dart';
import 'ConversationList.dart';

class ChatContacts extends StatefulWidget {
  static const String id = "chat_contacts";
  @override
  _ChatContactsState createState() => _ChatContactsState();
}

class _ChatContactsState extends State<ChatContacts> {
  final _auth = FirebaseAuth.instance;
  final _firebase = FirebaseFirestore.instance;
  List<ChatUsers> chatUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent[200],
      appBar: AppBar(
        //toolbarHeight: 150,
        elevation: 0,
        automaticallyImplyLeading: false,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        // ),
        centerTitle: true,
        // backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            gradient: LinearGradient(
              colors: [Colors.greenAccent[200], Colors.greenAccent[200]],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        title: Center(
            child: Text('Saviours', style: TextStyle(color: Colors.black))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.25,
            //   // decoration: BoxDecoration(
            //   //   borderRadius:
            //   //       BorderRadius.vertical(bottom: Radius.circular(18)),
            //   color: Colors.greenAccent[200],
            //   child: Center(
            //       child: Text('Saviours',
            //           style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 24,
            //           ))),
            // ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Column(
                children: <Widget>[
                  _auth.currentUser != null
                      ? StreamBuilder(
                          stream: _firebase
                              .collection("messages")
                              .orderBy("createdAt", descending: true)
                              .where("twoIds",
                                  arrayContains: _auth.currentUser.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            //initiate conversation list
                            List<ConversationList> conversations = [];
                            if (snapshot.hasData) {
                              //initiate array so we don't repeat conversations
                              List<String> alreadyProcessed = [
                                _auth.currentUser?.uid
                              ];
                              //snapshot docs
                              final snapshotDocs = snapshot.data.docs;

                              for (var item in snapshotDocs) {
                                //parse in the other user Id, has to be converted to string
                                List<String> ids = [];
                                for (var val in item['twoIds']) {
                                  ids.add(val.toString());
                                }
                                ids.remove(_auth.currentUser?.uid);
                                //if message chain from user has not been added yet
                                if (!alreadyProcessed.contains(ids[0])) {
                                  //create Conversation Card
                                  var c = ConversationList(
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
                              if (conversations.isEmpty) {
                                return Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 200),
                                    width: 250,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      image: new DecorationImage(
                                          colorFilter: new ColorFilter.mode(
                                              Colors.white.withOpacity(0.5),
                                              BlendMode.dstATop),
                                          image: AssetImage(
                                              'images/doughnut.png'),
                                          fit: BoxFit.contain),
                                    ),
                                    child: const Align(
                                        alignment: FractionalOffset(0.5, -0.2),
                                        child: Text(
                                          "It looks a bit empty here.",
                                          style: TextStyle(fontSize: 15),
                                        )),
                                  ),
                                );
                              } else {
                                return ListView(
                                    shrinkWrap: true, children: conversations);
                              }
                            } else {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (conversations.isEmpty) {
                                  return Center(child: Text("no messages"));
                                }
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return null;
                            }
                          })
                      : Text("Please login to send messages"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
