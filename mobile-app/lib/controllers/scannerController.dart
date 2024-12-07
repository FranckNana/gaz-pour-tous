import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gazpourtous/controllers/bottlesController.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerController extends GetxController {
  ScannerController({required this.targetStatus});

  final MobileScannerController controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates);
  StreamSubscription? _subscription;
  final BottlesController _bottlesController = Get.find();
  RxBool isReadyToScan = false.obs;
  RxBool isLoading = false.obs;
  BottleStatus targetStatus;

  @override
  void onReady() {
    // _subscription ??= controller.barcodes.listen(_onQrRead);
    super.onReady();
  }

  _onQrRead(BarcodeCapture capture) async {
    String? code = capture.barcodes.last.rawValue;
    if (code != null) {
      isLoading.value = true;
      controller.stop();
      print("========== code  =========== $code");
      String? res =
          await _bottlesController.onFillerBottleScanned(code, targetStatus);
      isLoading.value = false;
      String message;
      String title;
      Duration duration = const Duration(seconds: 2);

      Color bgColor = Colors.red.shade200;
      if (res == "success") {
        title = "Opération réussie";
        message = "Le statut de la bouteille a été mis à jour";
        bgColor = Colors.green.shade200;
      } else if (res == "forbidden") {
        title = "Echec";
        message = "Vous ne pouvez pas cette opération sur cette bouteille";
        duration = const Duration(seconds: 5);
      } else {
        title = "Echec";
        message = "une erreur s'est produite";
        duration = const Duration(seconds: 5);
      }
      toggleReadyToScan();
      Get.showSnackbar(GetSnackBar(
        duration: duration,
        title: title,
        message: message,
        backgroundColor: bgColor,
      ));
      controller.start();
    }
  }

  toggleReadyToScan() {
    isReadyToScan.value = !isReadyToScan.value;
  }

  @override
  void onClose() async {
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
    super.onClose();
  }
}
