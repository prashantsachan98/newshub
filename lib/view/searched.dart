import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: FutureBuilder<News>(
        future: RestApiManager().fetchNews('all_news'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "No Topics found",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    ListView.separated(
                        itemCount: snapshot.data.total,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              color: Get.isDarkMode
                                  ? Colors.blueGrey
                                  : Colors.black38,
                              height: 0,
                            ),
                        itemBuilder: (BuildContext context, int index) {
                          if (snapshot.data.articles[index].title
                              .toLowerCase()
                              .contains(searchedNews.toLowerCase())) {
                            return Container(
                              color:
                                  Get.isDarkMode ? Colors.black : Colors.white,
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                leading: Image(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  image: CachedNetworkImageProvider(
                                      snapshot.data.articles[index].imageUrl),
                                ),
                                title:
                                    Text(snapshot.data.articles[index].title),
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    CupertinoPageRoute<bool>(
                                      //fullscreenDialog: true,
                                      builder: (BuildContext context) => Source(
                                          snapshot
                                              .data.articles[index].sourceUrl),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          return SizedBox(height: 0);
                        }),
                  ],
                );
          }
        },
      ),
    );
  }
}
