import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gazpourtous/controllers/appController.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/default/widgets/scannerButtonWidget.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class LoginScanPage extends StatefulWidget {
  const LoginScanPage({super.key, required this.profile});

  final Profile profile;

  @override
  State<LoginScanPage> createState() => _LoginScanPageState();
}

class _LoginScanPageState extends State<LoginScanPage> {
  final MobileScannerController _controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates);
  StreamSubscription? _subscription;
  final AppController _appController = Get.find();

  @override
  void initState() {
    super.initState();
    _subscription = _controller.barcodes.listen(_onQrRead);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
      String? res = await _appController.login(code, widget.profile);
      if (res == "error") {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 2),
          title: "Echec de connexion",
          message: "Une erreur s'est produite",
        ));
        _controller.start();
      }
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
