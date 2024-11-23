import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRCodePage extends StatelessWidget {
  QRCodePage({super.key});

  AppController _appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.orangeColor,
        title: Text("Mon code QR"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(30),
          height: Get.width * .65,
          width: Get.width * .65,
          decoration: BoxDecoration(
              color: ColorsConstants.orangeColor.withOpacity(.6),
              borderRadius: BorderRadius.circular(8)),
          child: Obx(() {
            if (_appController.userQrCode.value.isNotEmpty) {
              return PrettyQrView.data(
                data: _appController.userQrCode.value,
              );
            } else {
              return Placeholder();
            }
          }),
        ),
      ),
    );
  }
}
