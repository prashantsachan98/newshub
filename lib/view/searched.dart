import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newshub/view/discover.dart';
import 'package:newshub/view/source.dart';
import '../networking/api.dart';
import '../model/news.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Search extends StatelessWidget {
  final String searchedNews;
  Search(this.searchedNews);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          Navigator.of(context).push(new PageRouteBuilder(
              opaque: true,
              transitionDuration: const Duration(milliseconds: 150),
              pageBuilder: (BuildContext context, _, __) {
                return Discover();
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
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder<News>(
        future: RestApiManager().fetchNews('all_news'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new Text('loading...');
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return ListView.builder(
                    itemCount: snapshot.data.total,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data.articles[index].title
                          .toLowerCase()
                          .contains(searchedNews.toLowerCase())) {
                        return ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          leading: Image(
                            width: MediaQuery.of(context).size.width * 0.2,
                            image: CachedNetworkImageProvider(
                                snapshot.data.articles[index].imageUrl),
                          ),
                          title: Text(snapshot.data.articles[index].title),
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<bool>(
                                //fullscreenDialog: true,
                                builder: (BuildContext context) => Source(
                                    snapshot.data.articles[index].sourceUrl),
                              ),
                            );
                          },
                        );
                      } else {
                        return null;
                      }
                    });
          }
        },
      ),
    );
  }
}
