import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/filler/pages/fillerScanPage.dart';
import 'package:gazpourtous/utils/utils.dart';
import 'package:get/get.dart';

class FillerActionsPage extends StatelessWidget {
  const FillerActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.orangeColor,
        title: Text("Mes actions"),
        actions: [Utils.getProfileChip("Emplisseur")],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Flexible(
              child: Text(
                "Quelle action souhaitez vous réaliser ?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              flex: 3,
              child: GridView.count(
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 2,
                children: [
                  Utils.builActionsPagedWidget(
                      "Scanner des bouteilles prêtes à être remplie",
                      FillerScanPage(
                          targetStatus:
                              BottleStatus.emptyReadyToBeFilledAtFiller),
                      ColorsConstants.orangeColor),
                  Utils.builActionsPagedWidget(
                      "Scanner des bouteilles prêtes à être livrées",
                      FillerScanPage(targetStatus: BottleStatus.filledAtFiller),
                      ColorsConstants.greenColor),
                  Utils.builActionsPagedWidget(
                      "Scanner des bouteilles en cours de livraison",
                      FillerScanPage(
                          targetStatus:
                              BottleStatus.filledAtFillerReadyToShipToMarketer),
                      ColorsConstants.greenColor)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
