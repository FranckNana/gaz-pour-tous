import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/models/bottleModel.dart';
import 'package:gazpourtous/services/bottleService.dart';
import 'package:get/get.dart';

class BottlesController extends GetxController {
  RxList<BottleModel> bottles = <BottleModel>[].obs;
  RxBool isLoading = false.obs;
  late BottleService _bottleService;

  @override
  void onInit() {
    _bottleService = Get.find();
    super.onInit();
  }

  @override
  void onReady() {
    getBottles();
    super.onReady();
  }

  void getBottles() async {
    isLoading.value = true;
    var result = await _bottleService.getBottles();
    bottles.value = result;
    isLoading.value = false;
  }

  Future<String> onFillerBottleScanned(code, targetStatus) async {
    String res;
    if (targetStatus == BottleStatus.filledAtFiller) {
      res = await _bottleService.fillerScanFilledBottle(code);
    } else if (targetStatus ==
        BottleStatus.filledAtFillerReadyToShipToMarketer) {
      res = await _bottleService
          .fillerScanFilledBottleReadyToDeliverToMarketer(code);
    } else if (targetStatus == BottleStatus.emptyReadyToBeFilledAtFiller) {
      res = await _bottleService.fillerScanReceivedEmptyBottle(code);
    } else {
      res = "forbidden";
    }
    if (res == "success") {
      getBottles();
    }
    return res;
  }

  Future<String> onResellerBottleScanned(
      BottleStatus targetStatus, bottleCode, clientCode) async {
    String res;
    if (targetStatus == BottleStatus.filledAtReseller) {
      res = await _bottleService.resellerReceiveFilledBottle(bottleCode);
    } else if (targetStatus == BottleStatus.emptyAtReseller) {
      res = await _bottleService.resellerReceiveEmptyBottleFromClient(
          bottleCode, clientCode);
    } else if (targetStatus == BottleStatus.emptyAtMarketer) {
      res = await _bottleService.resellerShipEmptyBottleToMarketer(bottleCode);
    } else {
      res = "forbidden";
    }
    if (res == "success") {
      getBottles();
    }
    return res;
  }

  Future<String> onResellerSellBottle(
      bottleCode, clientCode, paiementMode, amount, ref) async {
    String res = await _bottleService.resellerSellFilledBottleToClient(
        bottleCode, clientCode, amount, paiementMode, ref);

    if (res == "success") {
      getBottles();
    }
    return res;
  }

  Future<String> onMarketerBottleScanned(code, targetStatus) async {
    String res;
    if (targetStatus == BottleStatus.filledAtMarketer) {
      res = await _bottleService.marketerReceiveFilledBottle(code);
    } else if (targetStatus ==
        BottleStatus.filledAtMarketerReadyToShipToReseller) {
      res = await _bottleService.marketerShipFilledBottle(code);
    } else if (targetStatus == BottleStatus.emptyAtMarketer) {
      res = await _bottleService.marketerReceiveEmptyBottle(code);
    } else {
      res = "forbidden";
    }

    if (res == "success") {
      getBottles();
    }

    return res;
  }

  emptyBottleList() {
    bottles.clear();
  }

  Future<bool> validateBottleCode(String bottleCode) async {
    return await _bottleService.verifyBotteHash(bottleCode);
  }
}
