import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../model/news.dart';
import 'dart:async';

class RestApiManager {
  Future<News> fetchNews(data) async {
    var url = "https://inshortsv2.vercel.app/news?type=$data" + "&limit=200";
    // Await the http get response, then decode the json-formatted responce.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      var jsonResponse = convert.jsonDecode(response.body);

      final news = newsFromJson(response.body);

      return news;
    } else {
      print("Request failed with status: ${response.statusCode}.");

      return null;
    }
  }
}
