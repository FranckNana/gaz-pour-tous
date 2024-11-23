import 'package:gazpourtous/constants/apiConstants.dart';
import 'package:gazpourtous/constants/httpClient.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:get/get.dart';
import 'package:shared_prefs_cookie_store/shared_prefs_cookie_store.dart';

class AuthService {
  final _httpClient = HttpClient.getInstance();
  final SharedPrefCookieStore _sharedCookieStore = Get.find();

  Future<String> login(String code, Profile profile) async {
    final data = {
      "username": code,
      "password": code.replaceAll(" ", ""),
      "profil": profile.name
    };
    try {
      final response = await _httpClient.post(
        ApiConstants.loginEndpoint,
        data: data,
      );
      if (response.statusCode == 200) {
        return "success";
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  Future<String> logout() async {
    try {
      final response = await _httpClient.get(
        ApiConstants.logoutEndpoint,
      );
      if (response.statusCode == 200) {
        return "success";
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    } finally {
      await _sharedCookieStore.deleteAll();
    }
  }
}
