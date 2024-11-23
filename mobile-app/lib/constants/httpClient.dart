import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:get/get.dart';
import 'package:shared_prefs_cookie_store/shared_prefs_cookie_store.dart';

class HttpClient {
  static Dio? _instance;
  static CookieManager? cookieManager;
  static final SharedPrefCookieStore _cookieStore = Get.find();

  //static final cookieJar = Get.find();

  static Dio getInstance() {
    if (_instance == null) {
      _instance = Dio();
      _instance!.interceptors.add(CookieManager(_cookieStore));
      _instance!.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Sending request to ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Received response: $response');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          print('Error occurred: $error');
          return handler.next(error);
        },
      ));
    }
    return _instance!;
  }

/*  static Future<void> prepareCookiesManager() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final jar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(appDocPath + "/.cookies/"),
    );
    cookieManager = CookieManager(jar);
    _instance = Dio();
    _instance!.interceptors.add(cookieManager!);
  }*/

  void clearCookies() {
    _cookieStore.deleteAll();
  }
}
