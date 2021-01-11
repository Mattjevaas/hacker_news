import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class News{

  final int newsId;
  final String title;
  final String author;
  final int score;
  final String category;
  final String url;

  News({this.newsId, this.title, this.author, this.score, this.category, this.url});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      newsId: json['id'],
      title: json['title'],
      author: json['by'],
      score: json['score'],
      category: json['type'],
      url: json['url'],
    );
  }

}

class NewsController{

   int _count = 10;

  Future<Response> _getnews(int newsId) {
    return http.get('https://hacker-news.firebaseio.com/v0/item/$newsId.json?print=pretty');
  }

  Future<List<Response>> fetchNews(bool status) async {

    final response =
    await http.get('https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      if(status){
        _count+=5;
      }else{
        _count = 10;
      }

      //check count value
      //print(_count);

      Iterable l = json.decode(response.body);

      return Future.wait(l.take(_count).map((id) {
        return _getnews(id);
      }));


    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load news');
    }
  }

}