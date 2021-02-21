import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:url_launcher/url_launcher.dart';
import './networking/api.dart';
import './model/news.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './transformers/transformer.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      // title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder<News>(
      future: RestApiManager().fetchItunesAlbums(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              //print(snapshot.data.feed.results[0].artistName);
              print("yugandharrrr");

            return createListView(context, snapshot);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "News Hub",
          style: GoogleFonts.staatliches(),
        ),
      ),
      body: futureBuilder,
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    return TransformerPageView(
      scrollDirection: Axis.vertical,
      transformer: MyTransformer(),
      curve: Curves.easeInBack,
      itemCount: 99,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            // Note: Sensitivity is integer used when you don't want to mess up vertical drag
            if (details.primaryVelocity > 10) {
              // User swiped Left
              print('left');
            } else if (details.primaryVelocity < 10) {
              // User swiped Right
              _launchURL() async {
                final url = snapshot.data.articles[index].sourceUrl;
                if (await canLaunch(url)) {
                  launch(
                    url,
                    forceWebView: true,
                    enableJavaScript: true,
                  );
                } else {
                  throw 'Could not launch $url';
                }
              }

              _launchURL();
            }
          },
          child: Card(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width * 1,
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          snapshot.data.articles[index].imageUrl)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(snapshot.data.articles[index].title,
                      style: GoogleFonts.roboto(fontSize: 22)),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        'Author  ',
                        style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                      ),
                      Text(snapshot.data.articles[index].authorName)
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    snapshot.data.articles[index].description,
                    style: GoogleFonts.roboto(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
