import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/dataAPI/categorydata.dart';
import 'package:save_the_scran/models/ArticleModel.dart';
import 'package:save_the_scran/dataAPI/newsdata.dart';
import 'package:save_the_scran/models/CategoryModel.dart';
import 'package:save_the_scran/screens/News/NewsCategory.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'ArticleView.dart';

class NewsScreen extends StatefulWidget {
  static const String id = "news_screen";
  @override
  State<StatefulWidget> createState() => _NewsScreenState();
}


class _NewsScreenState extends State<NewsScreen> {
  List<CategoryModel> categories = [];
  List<ArticleModel> articles = [];

  bool _loading = true;

  @override
  void initState(){
    super.initState();
    categories = getCategory();
    getNews();
  }


  getNews() async{
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }



  //image file
  List<String> get imageSlides => [
    "images/slide0.jpg",
    "images/slide1.jpg",
    "images/slide2.jpg",
    "images/slide3.jpg"
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        centerTitle: true,
        // backgroundColor: Colors.white,
        title: Text('News', style: TextStyle(color: Colors.black)),
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

      ),
      body: SingleChildScrollView(

        child: Container(
          child: Column(

            children:<Widget>[
              SizedBox(height:20),
              CarouselSlider(
                options: CarouselOptions(
                  height: 500,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  autoPlay: true,
                ),
                items: imageSlides.map((e) => ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(e,
                          // fit: BoxFit.fitHeight,
                          color: ,
                          fit: BoxFit.contain,
                        )
                      ],

                    )
                )).toList(),
              ),

              // SizedBox(height:10),
              // Container(
              //   height: 70,
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //
              //   child: ListView.builder(
              //     itemCount: categories.length,
              //     shrinkWrap: true,
              //     scrollDirection:Axis.horizontal,
              //     itemBuilder: (context, index){
              //       return CategoryStyle(
              //         imageUrl: categories[index].imageUrl,
              //         categoryId: categories[index].categoryId,
              //       );}
              //   )
              //
              // ),
              //
              // SizedBox(height:10),
              // //news
              // _loading ? Center(
              //   child: Container(
              //     child: CircularProgressIndicator(),
              //   ),
              // ): Container(
              //     padding: EdgeInsets.symmetric(horizontal: 16),
              //
              //   child: ListView.builder(
              //     itemCount: articles.length,
              //     shrinkWrap: true,
              //     physics: ClampingScrollPhysics(),
              //     itemBuilder: (context,index){
              //       return NewsStyle(
              //         imageUrl: articles[index].urlToImage,
              //         title: articles[index].title,
              //         desc: articles[index].description,
              //         url: articles[index].url
              //       );
              //     }
              //   )
              // )
            ]
          )
        ),
      )
      );
  }

}

class CategoryStyle extends StatelessWidget{
  final String imageUrl, categoryId;
  CategoryStyle({this.imageUrl, this.categoryId
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Navigator.push(context, MaterialPageRoute(
          builder:(context)=> CategoryNews(
            category: categoryId.toLowerCase(),
          )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(imageUrl: imageUrl, width: 120, height: 60, fit: BoxFit.cover)),
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
      ),
    );
  }
}


class NewsStyle extends StatelessWidget{
  final String imageUrl, title, desc, url;
  NewsStyle({
  @required this.imageUrl,
  @required this.title,
  @required this.desc,
  @required this.url});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ArticleView(
            articleUrl: url,

          )

        ));
      },
      child: Container(
        child:Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child:Image.network(imageUrl)
            ),


            SizedBox(height:5),
            Text(title, style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            )),
            SizedBox(height:5),
            Text(desc, style: TextStyle(
                fontSize: 12,
                color: Colors.black54
            )),
            SizedBox(height:10),
          ],
        )
      ),
    );
  }
}
