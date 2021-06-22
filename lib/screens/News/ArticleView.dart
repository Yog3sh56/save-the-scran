import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget{

  final String articleUrl;
  ArticleView({this.articleUrl});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView>{

  final Completer<WebViewController> _completer = Completer<WebViewController>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
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
       body: Container(
            child: WebView(
              initialUrl: widget.articleUrl,
              onWebViewCreated: ((WebViewController webViewController){
                _completer.complete(webViewController);

              }),
            )
        )
    );
  }
}