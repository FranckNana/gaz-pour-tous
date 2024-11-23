import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/filler/pages/fillerScanPage.dart';
import 'package:get/get.dart';

class MarketerActionsPage extends StatelessWidget {
  const MarketerActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.orangeColor,
        title: Text("Mes actions"),
      ),
      body: Container(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Quelle action souhaitez vous réaliser ?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Get.to(() =>
                  FillerScanPage(targetStatus: BottleStatus.filledAtMarketer)),
              child: Text(
                "Scanner des bouteilles pleines reçues",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Get.to(() => FillerScanPage(
                  targetStatus:
                      BottleStatus.filledAtMarketerReadyToShipToReseller)),
              child: Text(
                "Scanner des bouteilles pleines prête à être livrées",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Get.to(() =>
                  FillerScanPage(targetStatus: BottleStatus.emptyAtMarketer)),
              child: Text(
                "Scanner des bouteilles vides reçues",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
