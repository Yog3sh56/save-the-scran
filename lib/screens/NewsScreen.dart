import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/models/Item.dart';
import 'package:save_the_scran/screens/RegistrationScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NewsScreen extends StatefulWidget {
  static const String id = "news_screen";
  @override
  State<StatefulWidget> createState() => _NewsScreenState();
}


class _NewsScreenState extends State<NewsScreen> {
  @override


  //image file
  final List<String> imageSlides = [
    "images/slide0.jpg",
    "images/slide1.jpg",
    "images/slide2.jpg",
    "images/slide3.jpg"
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        // iconTheme: IconThemeData(
        //   color: Colors.black,
        // ),
        // centerTitle: true,
        // backgroundColor: Colors.white,
        // title: Text('News', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        // backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            gradient: LinearGradient(
              colors: [Colors.greenAccent[200], Colors.greenAccent[200]],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        title: Text('News', style: TextStyle(color: Colors.black)),
      ),
      body: CarouselSlider(
        options: CarouselOptions(
          height: 300,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          autoPlay: true,
        ),
        items: imageSlides.map((e) => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(e,
                  fit: BoxFit.fitHeight,
                )
              ],

            )
        )).toList(),
      ),
      );
  }

}