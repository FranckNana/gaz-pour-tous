import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gazpourtous/controllers/bottlesController.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/default/widgets/scannerButtonWidget.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MarketerScanPage extends StatefulWidget {
  MarketerScanPage({super.key, required this.targetStatus});

  BottleStatus targetStatus;

  @override
  State<MarketerScanPage> createState() => _MarketerScanPageState();
}

class _MarketerScanPageState extends State<MarketerScanPage> {
  final MobileScannerController _controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates);
  StreamSubscription? _subscription;
  final BottlesController _bottlesController = Get.find();

  @override
  void initState() {
    super.initState();
    _subscription = _controller.barcodes.listen(_onQrRead);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: SizedBox.shrink(),
        actions: [
          IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.close, color: Colors.white))
        ],
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Placez le code QR dans le cadre",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 1,
                          color: Colors.white),
                    ),
                    Text("Le scan se fera automatiquement",
                        style: TextStyle(fontSize: 16, color: Colors.white))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: MobileScanner(
                controller: _controller,
              ),
            ),
            Expanded(
              child: Container(
                child: ToggleFlashlightButton(controller: _controller),
              ),
            )
          ],
        ),
      ),
    );
  }

  _onQrRead(BarcodeCapture capture) async {
    String? code = capture.barcodes.single.rawValue;
    if (mounted && code != null) {
      _controller.stop();
      print("========== code  =========== $code");
      String? res = await _bottlesController.onFillerBottleScanned(
          code, widget.targetStatus);
      String message;
      String title;
      Duration duration = Duration(seconds: 2);
      if (res == "success") {
        title = "Opération réussie";
        message = "Le statut de la bouteille a été mis à jour";
      } else if (res == "forbidden") {
        title = "Echec";
        message = "Vous ne pouvez pas cette opération sur cette bouteille";
        duration = Duration(seconds: 5);
      } else {
        title = "Echec";
        message = "une erreur s'est produite";
        duration = Duration(seconds: 5);
      }
      Get.showSnackbar(GetSnackBar(
        duration: duration,
        title: title,
        message: message,
      ));
      _controller.start();
    }
  }

  @override
  Future<void> dispose() async {
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await _controller.dispose();
  }
}
