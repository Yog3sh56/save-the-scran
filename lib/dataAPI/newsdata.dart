
import 'dart:convert';

import 'package:save_the_scran/models/ArticleModel.dart';
import 'package:http/http.dart' as http;

class News{
  List<ArticleModel> news = [];



  Future<void> getNews() async{


    String url = "https://newsapi.org/v2/top-headlines?q=food&apiKey=3660007ffa9943e6be6031237b67050f";


    var response = await http.get(url);

    var jsonformat = jsonDecode(response.body);

    if(jsonformat['status'] == "ok"){
      jsonformat['articles'].forEach((element){
        if(element['urlToImage'] != null && element['description']!= null){
          ArticleModel articleModel = ArticleModel(
            title:element['title'],
            author: element['author'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            // publishedAt: element['publishedAt"'],
            content: element['context']
          );
          news.add(articleModel);
        }

      });
    }

  }

}

class CategoryNewsClass{
  List<ArticleModel> news = [];



  Future<void> getNews(String category) async{
    // String url = 'https://newsapi.org/v2/everything?' +
    //     'q=food&' +
    //     // 'from=2021-06-21&' +
    //     'country=gb&' +
    //     'sortBy=popularity&' +
    //     'apiKey=3660007ffa9943e6be6031237b67050f';




    String url = "https://newsapi.org/v2/top-headlines?country=gb&category=$category&q=food&apiKey=3660007ffa9943e6be6031237b67050f";

    // String url = "https://newsapi.org/v2/top-headlines?q=food&from=2021-05-21&sortBy=publishedAt&apiKey=3660007ffa9943e6be6031237b67050f";


    var response = await http.get(url);

    var jsonformat = jsonDecode(response.body);

    if(jsonformat['status'] == "ok"){
      jsonformat['articles'].forEach((element){
        if(element['urlToImage'] != null && element['description']!= null){
          ArticleModel articleModel = ArticleModel(
              title:element['title'],
              author: element['author'],
              description: element['description'],
              url: element['url'],
              urlToImage: element['urlToImage'],
              // publishedAt: element['publishedAt"'],
              content: element['context']
          );
          news.add(articleModel);
        }

      });
    }

  }

}