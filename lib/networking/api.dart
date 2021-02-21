import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../model/news.dart';
import 'dart:async';

class RestApiManager {
  Future<News> fetchItunesAlbums() async {
    var url = "https://inshortsv2.vercel.app/news?type=all_news&limit=100";
    // Await the http get response, then decode the json-formatted responce.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);

      final news = newsFromJson(response.body);

      print(news);

      return news;
    } else {
      print("Request failed with status: ${response.statusCode}.");

      return null;
    }
  }
}
