import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/models/Item.dart';

class FoodWidgetProfile extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  String id;
  Item item;
  double foodProgress;
  Color progressColor;

  FoodWidgetProfile({this.item, this.id});

  void setExpiryProgress() {
    final today = DateTime.now();

    int totalDuration = item.expiry.difference(item.buyDate).inDays;
    int remaining = item.expiry.difference(today).inDays;

    double progress = 1 - remaining / totalDuration;
    this.foodProgress = progress;

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
        margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                          Text(item.name[0].toUpperCase() + item.name.substring(1),style: TextStyle(fontSize: 15),textAlign: TextAlign.center,),
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
                          Icon(Icons.home),
                          Text("Return to"),
                          Text("Fridge")
                        ],
                      ),
                      onTap: () {
                        _firestore
                            .collection("items")
                            .doc(id)
                            .update({"inCommunity": false});
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
