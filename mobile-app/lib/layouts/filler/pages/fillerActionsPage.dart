import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/filler/pages/fillerScanPage.dart';
import 'package:get/get.dart';

class FillerActionsPage extends StatelessWidget {
  const FillerActionsPage({super.key});

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
              onPressed: () => Get.to(() => FillerScanPage(
                  targetStatus: BottleStatus.emptyReadyToBeFilledAtFiller)),
              child: Text(
                "Scanner des bouteilles prêtes à être remplie",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Get.to(() =>
                  FillerScanPage(targetStatus: BottleStatus.filledAtFiller)),
              child: Text(
                "Scanner des bouteilles prêtes à être livrées",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Get.to(() => FillerScanPage(
                  targetStatus:
                      BottleStatus.filledAtFillerReadyToShipToMarketer)),
              child: Text(
                "Scanner des bouteilles en cours de livraison",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
