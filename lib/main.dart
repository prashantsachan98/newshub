import 'package:flutter/material.dart';
import 'package:newshub/view/discover.dart';
import 'package:newshub/view/source.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:flutter/cupertino.dart';

import './networking/api.dart';
import './model/news.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './transformers/transformer.dart';
import 'package:google_fonts/google_fonts.dart';

String newsType = 'all_news';
void main() {
  runApp(MyApp());
}

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
  String url;

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder<News>(
      future: RestApiManager().fetchNews(newsType),
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
      transformer: DeepthPageTransformer(),
      curve: Curves.easeInBack,
      itemCount: 100,
      itemBuilder: (BuildContext context, int index) {
        url = snapshot.data.articles[index].sourceUrl;
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            // Note: Sensitivity is integer used when you don't want to mess up vertical drag
            if (details.primaryVelocity > 10) {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute<bool>(
                  //fullscreenDialog: true,
                  builder: (BuildContext context) => Discover(),
                ),
              );
              // User swiped Left
              print('left');
            } else if (details.primaryVelocity < 10) {
              // User swiped Right
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute<bool>(
                  //fullscreenDialog: true,
                  builder: (BuildContext context) => Source(url),
                ),
              );
            }
          },
          child: Card(
            elevation: 10,
            //color: Colors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width * 1,
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          snapshot.data.articles[index].imageUrl),
                    ),
                  ),
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
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute<bool>(
                          //fullscreenDialog: true,
                          builder: (BuildContext context) => Source(url),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.amber,
                      shadowColor: Colors.amberAccent,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            'Read more at ${snapshot.data.articles[index].sourceName}',
                            style: GoogleFonts.harmattan(fontSize: 20)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
