import 'package:flutter/material.dart';
import 'package:save_the_scran/dataAPI/newsdata.dart';
import 'package:save_the_scran/models/ArticleModel.dart';
import 'package:save_the_scran/screens/News/ArticleView.dart';

import 'NewsScreen.dart';

class CategoryNews extends StatefulWidget{
  final String category;
  CategoryNews({this.category});
  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews>{
  List<ArticleModel> articles = [];
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCateNews();
  }

  getCateNews() async{
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getNews(widget.category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
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
      body:         //news
        _loading ? Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ): SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              SizedBox(height:10),
              Container(

                  padding: EdgeInsets.symmetric(horizontal: 16),

                  child: ListView.builder(
                      itemCount: articles.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context,index){
                        return NewsStyle(
                            imageUrl: articles[index].urlToImage,
                            title: articles[index].title,
                            desc: articles[index].description,
                            url: articles[index].url
                        );
                      }
                  )
              )
            ],
          ),
      ),
        )
    );
  }
}