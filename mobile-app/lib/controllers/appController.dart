import 'package:gazpourtous/controllers/bottlesController.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/services/authService.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppController extends GetxController {
  Rx<Profile> profile = Profile.none.obs;
  Rx<LoginStatus> loginStatus = LoginStatus.loading.obs;
  late final AuthService _authService;
  late GetStorage _storage;
  late BottlesController _bottlesController;
  RxString userQrCode = "".obs;
  bool loggedOut = false;

  @override
  void onInit() {
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
      userQrCode.value = _storage.read("code");
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
      userQrCode.value = code;
      profile.value = selectedProfile;
      loginStatus.value = LoginStatus.loggedIn;
      _storage.write("profile", selectedProfile.name);
      _storage.write("code", code);
      if (loggedOut) {
        _bottlesController.getBottles();
      }
      Get.back();
    }
    return null;
  }

  Future<String?> logout() async {
    await _authService.logout();
    profile.value = Profile.none;
    loginStatus.value = LoginStatus.none;
    _storage.remove("profile");
    _storage.remove("code");
    _bottlesController = Get.find();
    _bottlesController.emptyBottleList();
    loggedOut = true;
    return null;
  }
}
