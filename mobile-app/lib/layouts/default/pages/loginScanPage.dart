import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/controllers/appController.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/default/widgets/progressIndicator.dart';
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
      detectionSpeed: DetectionSpeed.noDuplicates,
      autoStart: false);
  StreamSubscription? _subscription;
  final AppController _appController = Get.find();
  bool isReadyToScan = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _subscription ??= _controller.barcodes.listen(_onQrRead);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: const Text(
          "Connexion",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: Get.width,
        child: Column(
          children: [
            const Expanded(
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
                  Text("Cliquez sur scanner lorsque vous êtes prêt",
                      style: TextStyle(fontSize: 16, color: Colors.white))
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: isLoading
                    ? const GPTProgressindicator()
                    : (isReadyToScan
                        ? MobileScanner(
                            controller: _controller,
                          )
                        : Center(
                            child: TextButton(
                              onPressed: () {
                                _controller.start();
                                _toggleReadyToScan();
                              },
                              child: const Text(
                                "Scanner",
                                style: TextStyle(
                                    color: ColorsConstants.orangeColor,
                                    fontSize: 23),
                              ),
                            ),
                          ))),
            Expanded(
              child: ToggleFlashlightButton(controller: _controller),
            )
          ],
        ),
      ),
    );
  }

  _onQrRead(BarcodeCapture capture) async {
    String? code = capture.barcodes.single.rawValue;
    if (mounted && code != null) {
      setState(() {
        isLoading = true;
      });
      _controller.stop();
      print("========== code  =========== $code");
      String? res = await _appController.login(code, widget.profile);
      setState(() {
        isLoading = false;
      });
      if (res == "error") {
        _toggleReadyToScan();
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          title: "Echec de connexion",
          message: "Une erreur s'est produite",
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  _toggleReadyToScan() {
    setState(() {
      isReadyToScan = !isReadyToScan;
    });
  }

  @override
  Future<void> dispose() async {
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await _controller.dispose();
  }
}
