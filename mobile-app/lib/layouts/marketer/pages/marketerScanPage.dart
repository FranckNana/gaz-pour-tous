import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/controllers/bottlesController.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/default/widgets/progressIndicator.dart';
import 'package:gazpourtous/layouts/default/widgets/scannerButtonWidget.dart';
import 'package:gazpourtous/utils/utils.dart';
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
      autoStart: false,
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates);
  StreamSubscription? _subscription;
  final BottlesController _bottlesController = Get.find();
  bool isReadyToScan = false;
  bool isLoading = false;

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
          Utils.getProfileChip("Marketeur"),
          IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.close, color: Colors.white))
        ],
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
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
    _controller.stop();
    String? code = capture.barcodes.last.rawValue;
    if (mounted && code != null) {
      setState(() {
        isLoading = true;
      });
      print("========== code  =========== $code");
      bool validHash = await _bottlesController.validateBottleCode(code);

      if (validHash) {
        String? res = await _bottlesController.onMarketerBottleScanned(
            code, widget.targetStatus);
        setState(() {
          isLoading = false;
        });
        String message;
        String title;
        Duration duration = Duration(seconds: 2);

        Color bgColor = Colors.red.shade200;
        if (res == "success") {
          title = "Opération réussie";
          message = "Le statut de la bouteille a été mis à jour";
          bgColor = Colors.green.shade200;
        } else if (res == "forbidden") {
          title = "Echec";
          message = "Vous ne pouvez pas cette opération sur cette bouteille";
          duration = Duration(seconds: 5);
        } else {
          title = "Echec";
          message = "une erreur s'est produite";
          duration = Duration(seconds: 5);
        }
        _toggleReadyToScan();
        Get.showSnackbar(GetSnackBar(
          duration: duration,
          title: title,
          message: message,
          backgroundColor: bgColor,
        ));
      } else {
        setState(() {
          isLoading = false;
          isReadyToScan = false;
        });
        Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 2),
          title: "Erreur",
          message: "Le code de cette bouteille n'est pas reconnu",
          backgroundColor: Colors.red.shade300,
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
