import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';

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
    return Container(
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          if (details.primaryVelocity < 10) {
            // User swiped Left

          } else if (details.primaryVelocity > 10) {
            // User swiped Right
            Navigator.pop(context);
          }
        },
        child: WebView(
          initialUrl: url,
        ),
      ),
    );
  }
}
