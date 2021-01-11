import 'package:flutter/material.dart';

import 'package:hacker_news/news.dart';

class NewsCard extends StatelessWidget {

  final News news;
  final Function open;

  NewsCard({this.news, this.open});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      child: Card(
        margin: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: InkWell(
          onTap: (){
            Navigator.pushNamed(
                context,
                '/webview',
                arguments: news
            );
          },
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    news.title,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MiniDesc(data: news.author, icon: Icons.person),
                      MiniDesc(data: news.score.toString(), icon: Icons.score),
                      MiniDesc(data: news.category, icon: Icons.category),
                    ],
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}

class MiniDesc extends StatelessWidget {
  const MiniDesc({
    Key key,
    @required this.icon,
    @required this.data,
  }) : super(key: key);

  final String data;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 10.0,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            data,
            style: TextStyle(
                fontSize: 10.0
            ),
          )
        ],
      ),
    );
  }
}