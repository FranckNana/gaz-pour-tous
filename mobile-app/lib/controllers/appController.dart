import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/services/authService.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppController extends GetxController {
  Rx<Profile> profile = Profile.none.obs;
  Rx<LoginStatus> loginStatus = LoginStatus.loading.obs;
  late final AuthService _authService;
  late GetStorage _storage;

  @override
  void onInit() {
    // TODO: implement onInit
    _authService = Get.find();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void onReady() async {
    await GetStorage.init();
    _storage = GetStorage();
    String? val = _storage.read("profile");
    if (val != null) {
      loginStatus.value = LoginStatus.loggedIn;
      profile.value = Profile.values.byName(val);
    } else {
      loginStatus.value = LoginStatus.none;
    }
    super.onReady();
  }

  Future<String?> login(code, Profile selectedProfile) async {
    String res = await _authService.login(code, selectedProfile);
    if (res != "success") {
      return res;
    } else {
      profile.value = selectedProfile;
      loginStatus.value = LoginStatus.loggedIn;
      _storage.write("profile", selectedProfile.name);

      Get.back();
    }
    return null;
  }

  Future<String?> logout() async {
    String res = await _authService.logout();
    if (res != "success") {
      profile.value = Profile.none;
      loginStatus.value = LoginStatus.none;
      _storage.remove("profile");
      return res;
    } else {
      profile.value = Profile.none;
      loginStatus.value = LoginStatus.none;
      _storage.remove("profile");
    }
    return null;
  }
}
