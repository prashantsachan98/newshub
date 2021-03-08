import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Source extends StatelessWidget {
  final String url;
  Source(this.url);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        shadowColor: Color.fromRGBO(0, 0, 0, 0),
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
      ),
      body: WebView(
        initialUrl: url,
        
        gestureNavigationEnabled: true,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
