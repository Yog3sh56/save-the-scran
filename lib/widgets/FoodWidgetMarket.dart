import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/chat/ChatScreen.dart';

class FoodWidgetMarket extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final id;
  final ownerid;
  final item;
  double foodProgress;
  Color progressColor;

  FoodWidgetMarket({this.item, this.id, this.ownerid});

  void setExpiryProgress() {
    final today = DateTime.now();

    int totalDuration = item.expiry.difference(item.buyDate).inDays;
    int remaining = item.expiry.difference(today).inDays;


    double progress = 1 - remaining / totalDuration;
    this.foodProgress = progress.isNaN?0.1:progress;



    if (foodProgress <= 0.6) {
      this.progressColor = Colors.green;
    }
    if (foodProgress > 0.6) {
      this.progressColor = Colors.yellow;
    }
    if (foodProgress > 0.8) {
      this.progressColor = Colors.orange;
    }
    if (foodProgress > 0.9) {
      this.progressColor = Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    setExpiryProgress();
    return Card(
      elevation: 15,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(children: [
              Row(mainAxisSize: MainAxisSize.max, children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: new BoxDecoration(
                      color: progressColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Column(children: [
                      Text(
                        item.name[0].toUpperCase() + item.name.substring(1),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "Expiry" +
                            item.expiry.day.toString() +
                            "/" +
                            item.expiry.month.toString() +
                            "/" +
                            item.expiry.year.toString(),
                        style: TextStyle(fontSize: 11),
                      ),
                    ])),
                Expanded(
                  flex: 1,
                  child: InkResponse(
                      radius: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.send),
                          Text("Message "),
                          Text("owner")
                        ],
                      ),
                      onTap: () {
                        _auth.currentUser != null
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      otherPerson: this.ownerid,
                                      itemName: this.item.name),
                                ),
                              )
                            : print("not signed in");
                        ;
                      }),
                )
              ]),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              LinearProgressIndicator(
                value: this.foodProgress,
                valueColor: AlwaysStoppedAnimation<Color>(
                  this.progressColor,
                ),
                backgroundColor: Colors.black,
              )
            ])));
  }
}
