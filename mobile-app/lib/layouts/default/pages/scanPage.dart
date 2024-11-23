import 'package:flutter/material.dart';
import 'package:gazpourtous/layouts/default/widgets/scannerButtonWidget.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

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
                onDetect: (capture) {
                  print("========== ${capture.barcodes.firstOrNull?.rawValue}");
                  if (mounted) {
                    print(
                        "========== ${capture.barcodes.firstOrNull?.rawValue}");
                    Get.back(result: capture.barcodes.firstOrNull?.rawValue);
                  }
                },
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

  @override
  Future<void> dispose() async {
    super.dispose();
    await _controller.dispose();
  }
}
