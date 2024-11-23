import 'package:flutter/material.dart';
import 'package:gazpourtous/layouts/default/widgets/scannerButtonWidget.dart';
import 'package:gazpourtous/layouts/default/widgets/scannerOverlay.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool isScanCompleted = false;
  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  void closeScanner() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 200,
      height: 200,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
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
            MobileScanner(
              fit: BoxFit.contain,
              scanWindow: scanWindow,
              controller: _controller,
              onDetect: (capture) {
                if (mounted) {
                  print("========== ${capture.barcodes.firstOrNull?.rawValue}");
                  Get.back(result: capture.barcodes.firstOrNull?.rawValue);
                }
              },
            ),
            ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, value, child) {
                if (!value.isInitialized ||
                    !value.isRunning ||
                    value.error != null) {
                  return const SizedBox();
                }
                return CustomPaint(
                  painter: ScannerOverlay(scanWindow: scanWindow),
                );
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 50),
              child: ToggleFlashlightButton(controller: _controller),
            )
          ],
        ),
      ),
    );
  }
}
