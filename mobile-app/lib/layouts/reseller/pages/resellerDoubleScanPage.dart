import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/controllers/bottlesController.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/default/widgets/progressIndicator.dart';
import 'package:gazpourtous/layouts/default/widgets/scannerButtonWidget.dart';
import 'package:gazpourtous/layouts/reseller/pages/resellerPaiementPage.dart';
import 'package:gazpourtous/utils/utils.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ResellerDoubleScanPage extends StatefulWidget {
  ResellerDoubleScanPage({super.key, required this.targetStatus});

  BottleStatus targetStatus;

  @override
  State<ResellerDoubleScanPage> createState() => _ResellerDoubleScanPageState();
}

class _ResellerDoubleScanPageState extends State<ResellerDoubleScanPage> {
  final MobileScannerController _controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
      autoStart: false);
  StreamSubscription? _subscription;
  final BottlesController _bottlesController = Get.find();
  String? clientCode;
  String? bottleCode;
  bool isReadyToScan = false;
  bool isLoading = false;
  int step = 0;

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
        automaticallyImplyLeading: false,
        title: Text(
          step == 0 ? "Scannez le code client" : "Scannez la bouteille",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          Utils.getProfileChip("Revendeur"),
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: const Column(
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
                            child: Text(
                              step == 0 && clientCode == null ||
                                      step == 1 && bottleCode == null
                                  ? "Scanner"
                                  : "Scanner à nouveau",
                              style: const TextStyle(
                                  color: ColorsConstants.orangeColor,
                                  fontSize: 23),
                            ),
                          ),
                        )),
            ),
            clientCode != null && step == 0
                ? Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          step = 1;
                        });
                      },
                      child: const Text(
                        "Etape suivante",
                        style: TextStyle(
                            color: ColorsConstants.orangeColor, fontSize: 23),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
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
      _controller.stop();
      if (step == 0) {
        setState(() {
          isReadyToScan = false;
          clientCode = code;
        });
      } else {
        setState(() {
          isReadyToScan = false;
        });
        bottleCode = code;
        print("================== $bottleCode =============== $clientCode");
        bool isValid = await _bottlesController.validateBottleCode(bottleCode!);
        if (isValid) {
          if (widget.targetStatus == BottleStatus.filledAtClient) {
            Get.to(() => ResellerPaiementPage(
                bottleCode: bottleCode!,
                clientCode: clientCode!,
                targetStatus: widget.targetStatus));
          } else {
            _handleBottleScanned(clientCode, bottleCode);
          }
        } else {
          _handleUnvalidBottle();
        }
      }
    }
  }

  Future<void> _handleBottleScanned(clientCode, bottleCode) async {
    setIsLoading(true);
    String title;
    String message;
    String res = await _bottlesController.onResellerBottleScanned(
        widget.targetStatus, bottleCode, clientCode);
    Duration duration = Duration(seconds: 5);
    Color bgColor = Colors.red.shade200;
    if (res == "success") {
      title = "Opération réussie";
      message = "Le statut de la bouteille a été mis à jour";
      bgColor = Colors.green.shade200;
    } else if (res == "forbidden") {
      title = "Echec";
      message =
          "Vous ne pouvez pas réaliser cette opération sur cette bouteille";
    } else {
      title = "Echec";
      message = "une erreur s'est produite";
    }
    setIsLoading(false);
    Get.back();
    Get.showSnackbar(GetSnackBar(
      duration: duration,
      title: title,
      message: message,
      backgroundColor: bgColor,
    ));
  }

  _handleUnvalidBottle() {
    Get.showSnackbar(GetSnackBar(
      duration: const Duration(seconds: 2),
      title: "Erreur",
      message: "Le code de cette bouteille n'est pas reconnu",
      backgroundColor: Colors.red.shade300,
    ));
  }

  _toggleReadyToScan() {
    setState(() {
      isReadyToScan = !isReadyToScan;
      if (step == 0) {
        clientCode = null;
      }
    });
  }

  setIsLoading(bool value) {
    setState(() {
      isLoading = value;
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
