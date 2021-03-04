import 'package:get/get.dart';
import '../networking/api.dart';

class Controller extends GetxController {
  String newsType = 'all_news'.obs.toString();
  String urlType = 'www.google.com'.obs.toString();

  @override
  void onInit() {
    super.onInit();
    RestApiManager().fetchNews(newsType);
  }
}
