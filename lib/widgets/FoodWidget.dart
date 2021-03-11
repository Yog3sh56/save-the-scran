import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FoodWidget extends StatelessWidget{

  final DateTime expiry;
  final DateTime bought;
  final String name;
  double foodProgress;
  Color progressColor;

  FoodWidget({this.name,this.expiry, this.bought}); 


  void setExpiryProgress(){
    final today = DateTime.now();
    int totalDuration = expiry.difference(bought).inDays;
    int remaining = expiry.difference(today).inDays;
    double progress = 1-remaining/totalDuration;
    this.foodProgress = progress;


    if (foodProgress < 0.5){ this.progressColor = Colors.green;}
    if (foodProgress > 0.6 ){ this.progressColor = Colors.yellow;}
    if (foodProgress > 0.8 ){ this.progressColor = Colors.orange;}
    if (foodProgress > 0.9 ){ this.progressColor = Colors.red;}


  }

  @override
  Widget build(BuildContext context) {
    setExpiryProgress();
    return Card(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
      child: 
      Padding(padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      child:
      Column(
        children:[
        Row(
        mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: new BoxDecoration(
                color: progressColor,
                shape: BoxShape.circle,
              ),),
            Padding(padding: EdgeInsets.only(left: 15)),
            Text(name),
            Padding(padding: EdgeInsets.only(left: 15)),
            Column(children: [
              Text("Expiry"),
              Text(expiry.day.toString() +"/"+ expiry.month.toString()+"/"+expiry.year.toString()),
            ],),  
            Padding(padding: EdgeInsets.only(right: 40)),
            
           InkResponse(
              radius: 50,
              child:
            Column(mainAxisAlignment: MainAxisAlignment.end,
              
              children: [
                Icon(Icons.storefront),
                
                
              
              Text("Send to community")
            ],),
            onTap: ()=>print("send to market"),)
            
            
           ]
        ),
        Padding(padding: EdgeInsets.only(bottom:20)),
        LinearProgressIndicator(
          value: this.foodProgress,
          valueColor:  AlwaysStoppedAnimation<Color>(this.progressColor,),
          backgroundColor: Colors.black,
        )]
    )));
  }

}