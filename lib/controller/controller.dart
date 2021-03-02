import 'package:get/get.dart';
import '../networking/api.dart';

class Controller extends GetxController {
  String newsType = 'all_news'.obs.toString();
  int i = 1.obs();

  @override
  void onInit() {
    super.onInit();
    RestApiManager().fetchNews(newsType);
  }
}
