import 'package:gazpourtous/controllers/appController.dart';
import 'package:gazpourtous/controllers/bottlesController.dart';
import 'package:gazpourtous/services/authService.dart';
import 'package:gazpourtous/services/bottleService.dart';
import 'package:get/get.dart';
import 'package:shared_prefs_cookie_store/shared_prefs_cookie_store.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppController());
    Get.lazyPut(() => BottlesController());
    Get.lazyPut(() => SharedPrefCookieStore());
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => BottleService());
  }
}
