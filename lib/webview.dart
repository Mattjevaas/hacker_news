
import 'package:share/share.dart';
import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:hacker_news/news.dart';

class WebViewer extends StatefulWidget {
  @override
  _WebViewerState createState() => _WebViewerState();
}

class _WebViewerState extends State<WebViewer> {

  double _lineProgress = 0.0;
  FlutterWebviewPlugin _flutterWebviewPlugin = FlutterWebviewPlugin();

  _progressBar(double progress,BuildContext context) {

    return LinearProgressIndicator(
      backgroundColor: Colors.white70.withOpacity(0),
      value: progress == 1.0 ? 0 : progress,
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
  
  _shareUrl(BuildContext context, String url) async {

    final RenderBox box = context.findRenderObject();

    await Share.share(
      url,
      subject: "News Url ${url}",
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _flutterWebviewPlugin.onProgressChanged.listen((progress){
      setState(() {
        _lineProgress = progress;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final News news = ModalRoute.of(context).settings.arguments;

    return WebviewScaffold(
        appBar: AppBar(
          title: Text(news.title),
          centerTitle: true,
          bottom: PreferredSize(
            child: _progressBar(_lineProgress,context),
            preferredSize: Size.fromHeight(3.0),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.share),
                onPressed: (){
                  _shareUrl(context, news.url);
                },
            )
          ],
        ),
        url: news.url
    );
  }
}


