import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hacker_news/news.dart';
import 'package:hacker_news/webview.dart';
import 'package:hacker_news/news_card.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News',
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.black45,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/webview': (context) => WebViewer(),
      },
      
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<News> _news = [];
  NewsController _newsController = new NewsController();
  bool _isLoading = false;
  // bool _stat = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _populateTopNews(false);
  }

  void _populateTopNews(bool status) async {

    final responses = await _newsController.fetchNews(status);
    final news = responses.map((response) {
      final json = jsonDecode(response.body);
      return News.fromJson(json);
    }).toList();

    setState(() {
      _news = news;
      _isLoading = false;
      // _stat = true;
    });
  }

  Future<void> _refreshData() async{
    _news.clear();
    setState(() {});
    _populateTopNews(false);
  }

  Future<void> _loadMore() async{

    //dont load if already onLoadMore
    if(!_isLoading){
      setState(() {
        _isLoading = true;
      });
      _populateTopNews(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Hacker News"),
          backgroundColor: Colors.black54,
          centerTitle: true,
          elevation: 0.0,
        ),
        body: (_news.isEmpty) ?
          Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(backgroundColor: Colors.white),
          ) :
          Stack(
            children: <Widget>[

              LazyLoadScrollView(
                onEndOfPage: (){
                  _loadMore();
                },
                child: RefreshIndicator(
                  onRefresh: (){
                    return _refreshData();
                  },
                  child: ListView.builder(
                    itemCount: _news.length,
                    itemBuilder: (context, index){
                      return NewsCard(news: _news[index],open: (){});
                    },
                  ),
                )
              ),
              (
                _isLoading ?
                Container(
                    color: Colors.black.withOpacity(0.8)
                ) : Container()
              ),
              (
                _isLoading ?
                Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(backgroundColor: Colors.white),
                )
                    : Container()
              ),
            ]
          ),
      ),
    );
  }
}

