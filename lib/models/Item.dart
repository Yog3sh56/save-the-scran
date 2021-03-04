import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Item {
  String ownerid;
  String name;
  DateTime buyDate;
  DateTime expiry;
  
  Item(this.ownerid,this.name,{this.buyDate,this.expiry}){
    if (this.buyDate == null){
      buyDate = DateTime.now();
      this.expiry = buyDate.add(Duration(days:20));
    }
  }







}
