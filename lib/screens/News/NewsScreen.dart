import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/dataAPI/newsdata.dart';
import 'package:save_the_scran/models/CategoryModel.dart';
import 'package:save_the_scran/models/Item.dart';
import 'package:save_the_scran/screens/RegistrationScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NewsScreen extends StatefulWidget {
  static const String id = "news_screen";
  @override
  State<StatefulWidget> createState() => _NewsScreenState();
}


class _NewsScreenState extends State<NewsScreen> {
  List<CategoryModel> categories = [];

  @override
  void initState(){
    super.initState();
    categories = getCategory();
  }

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
      body: Container(

        child: Column(
          children:<Widget>[
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
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
                        // fit: BoxFit.fitHeight,
                        fit: BoxFit.cover,
                      )
                    ],

                  )
              )).toList(),
            ),
            Container(
              height: 70,
              padding: EdgeInsets.symmetric(horizontal: 16),

              child: ListView.builder(
                itemCount: categories.length,
                shrinkWrap: true,
                scrollDirection:Axis.horizontal,
                itemBuilder: (context, index){
                  return Category(
                    imageUrl: categories[index].imageUrl,
                    categoryId: categories[index].categoryId,
                  );}
              )

            )
          ]
        )
      )
      );
  }

}

class Category extends StatelessWidget{
  final imageUrl, categoryId;
  Category({this.imageUrl, this.categoryId
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
              child: Image.network(imageUrl, width: 120, height: 60, fit: BoxFit.cover)),
          Container(
            alignment: Alignment.center,
            width: 120, height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black38,
            ),

            child:Text(categoryId, style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600
            ),)
          ),
        ],
      ),
    );
  }
}

class News extends StatelessWidget{
  final String imageUrl, title, desc;
  News({
  @required this.imageUrl,
  @required this.title,
  @required this.desc});

  @override
  Widget build(BuildContext context){
    return Container(
      child:Column(
        children: <Widget>[
          Image.network(imageUrl),
          Text(title),
          Text(desc)
        ],
      )
    );
  }
}
