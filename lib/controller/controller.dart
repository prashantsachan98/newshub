import 'package:get/get.dart';
import '../networking/api.dart';

class Controller extends GetxController {
  String newsType = 'national'.obs.toString();

  @override
  void onInit() {
    super.onInit();
    RestApiManager().fetchNews(newsType);
  }
}
