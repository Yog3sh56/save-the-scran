import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/models/Item.dart';

// ignore: must_be_immutable
class FoodWidget extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  String id;
  Item item;
  double foodProgress;
  Color progressColor;

  FoodWidget({this.item, this.id});

  void setExpiryProgress() {
    final today = DateTime.now();

    int totalDuration = item.expiry.difference(item.buyDate).inDays;
    int remaining = item.expiry.difference(today).inDays;

    double progress = 1 - remaining / totalDuration;
    print(progress);
    //this.foodProgress = progress;
    this.foodProgress = Random().nextDouble();

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
        onDismissed: (DismissDirection direction) {
          _firestore.collection("items").doc(id).delete();
        },
        child: Card(
          
            margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
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
                    Padding(padding: EdgeInsets.only(left: 15)),
                    Expanded(flex: 1, child: Text(item.name)),
                    Padding(padding: EdgeInsets.only(left: 15)),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text("Expiry"),
                          Text(
                            item.expiry.day.toString() +
                                "/" +
                                item.expiry.month.toString() +
                                "/" +
                                item.expiry.year.toString(),
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 40)),
                    Expanded(
                      flex: 2,
                      child: InkResponse(
                          radius: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.storefront),
                              Text("Send to community"),
                            ],
                          ),
                          onTap: () {
                            bool changeTo = true;
                            if (item.inCommunity) changeTo = false;
                            _firestore
                                .collection("items")
                                .doc(id)
                                .update({"inCommunity": changeTo});
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
                ]))));
  }
}
