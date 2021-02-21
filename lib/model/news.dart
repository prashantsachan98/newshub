// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
  News({
    this.total,
    this.articles,
  });

  final int total;
  final List<Article> articles;

  factory News.fromJson(Map<String, dynamic> json) => News(
        total: json["total"],
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}

class Article {
  Article({
    this.title,
    this.description,
    this.authorName,
    this.sourceName,
    this.sourceUrl,
    this.imageUrl,
    this.createdAt,
    this.inshortsUrl,
  });

  final String title;
  final String description;
  final String authorName;
  final String sourceName;
  final String sourceUrl;
  final String imageUrl;
  final int createdAt;
  final String inshortsUrl;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json["title"],
        description: json["description"],
        authorName: json["author_name"],
        sourceName: json["source_name"],
        sourceUrl: json["source_url"],
        imageUrl: json["image_url"],
        createdAt: json["created_at"],
        inshortsUrl: json["inshorts_url"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "author_name": authorName,
        "source_name": sourceName,
        "source_url": sourceUrl,
        "image_url": imageUrl,
        "created_at": createdAt,
        "inshorts_url": inshortsUrl,
      };
}

/*

ListTile(
              leading: Image(
                  image: new CachedNetworkImageProvider(
                      snapshot.data.articles[index].imageUrl)),
              title: new Text(snapshot.data.articles[index].title),
            ),
            new Divider(
              height: 2.0,
            ),
          ],
        );
      },
    );

    */
