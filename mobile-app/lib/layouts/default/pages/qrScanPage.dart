import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanPage extends StatefulWidget {
  QRScanPage(
      {super.key, required this.scannerController, required this.onRead});

  MobileScannerController scannerController;
  VoidCallback onRead;

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
