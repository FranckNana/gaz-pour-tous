import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/marketer/pages/marketerScanPage.dart';
import 'package:gazpourtous/utils/utils.dart';
import 'package:get/get.dart';

class MarketerActionsPage extends StatelessWidget {
  const MarketerActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.orangeColor,
        title: const Text("Mes actions"),
        actions: [Utils.getProfileChip("Marketeur")],
      ),
      body: Container(
        width: Get.width,
        padding: const EdgeInsets.all(20),
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
                      "Scanner des bouteilles pleines reçues",
                      MarketerScanPage(
                          targetStatus: BottleStatus.filledAtMarketer),
                      ColorsConstants.orangeColor),
                  Utils.builActionsPagedWidget(
                      "Scanner des bouteilles pleines prête à être livrées",
                      MarketerScanPage(
                          targetStatus: BottleStatus
                              .filledAtMarketerReadyToShipToReseller),
                      ColorsConstants.greenColor),
                  Utils.builActionsPagedWidget(
                      "Scanner des bouteilles vides reçues",
                      MarketerScanPage(
                          targetStatus: BottleStatus.emptyAtMarketer),
                      ColorsConstants.greenColor),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
