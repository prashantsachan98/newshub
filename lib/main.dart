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
    return MaterialApp(
      theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      })),
      // title: 'Flutter Demo',

      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url;

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder<News>(
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
              return createListView(context, snapshot);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        title: Container(
          width: MediaQuery.of(context).size.width * 1,
          child: Card(
            shadowColor: Color.fromRGBO(229, 19, 36, 1),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Text(
                'News Hub',
                style: GoogleFonts.lobster(
                    letterSpacing: 1,
                    fontSize: 30,
                    color: Color.fromRGBO(229, 19, 36, 1)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
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
      itemCount: snapshot.data.total,
      itemBuilder: (BuildContext context, int index) {
        url = snapshot.data.articles[index].sourceUrl;
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            // Note: Sensitivity is integer used when you don't want to mess up vertical drag
            if (details.primaryVelocity > 10) {
              Navigator.of(context).push(new PageRouteBuilder(
                  opaque: true,
                  transitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (BuildContext context, _, __) {
                    return Discover();
                  },
                  transitionsBuilder:
                      (_, Animation<double> animation, __, Widget child) {
                    return new SlideTransition(
                      child: child,
                      position: new Tween<Offset>(
                        begin: const Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                    );
                  }));
              // User swiped Left
              print('left');
            } else if (details.primaryVelocity < 10) {
              // User swiped Right
              Navigator.of(context).push(new PageRouteBuilder(
                  opaque: true,
                  transitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (BuildContext context, _, __) {
                    return Source(url);
                  },
                  transitionsBuilder:
                      (_, Animation<double> animation, __, Widget child) {
                    return new SlideTransition(
                      child: child,
                      position: new Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                    );
                  }));
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      style: GoogleFonts.roboto(fontSize: 23)),
                  SizedBox(
                    height: 10,
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
                        fontSize: 18, wordSpacing: 3, height: 1.1),
                  ),
                  SizedBox(height: 7),
                  InkWell(
                    splashColor: Colors.black,
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
                            style: GoogleFonts.harmattan(fontSize: 21)),
                      ),
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
