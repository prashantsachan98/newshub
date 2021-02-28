import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Source extends StatelessWidget {
  final String url;
  Source(this.url);
  /*_launchURL(url) async {
    if (await canLaunch(url)) {
      launch(
        url,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }*/

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 1,
        shadowColor: Color.fromRGBO(0, 0, 0, 0),
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          if (details.primaryVelocity < 10) {
            // User swiped Left

          } else if (details.primaryVelocity > 10) {
            // User swiped Right
            //   Navigator.pop(context);
          }
        },
        child: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
      floatingActionButton: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Container(
          child: Text(
            'back',
            style: TextStyle(fontSize: 20, color: Colors.blueGrey),
          ),
          color: Colors.amber,
        ),
        color: Colors.amber,
      ),
    );
  }
}
