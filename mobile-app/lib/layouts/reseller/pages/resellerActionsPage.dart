import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/reseller/pages/resellerDoubleScanPage.dart';
import 'package:gazpourtous/layouts/reseller/pages/resellerScanPage.dart';
import 'package:gazpourtous/utils/utils.dart';
import 'package:get/get.dart';

class ResellerActionsPage extends StatelessWidget {
  const ResellerActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.orangeColor,
        title: const Text("Mes actions"),
        actions: [Utils.getProfileChip("Revendeur")],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                        ResellerScanPage(
                            targetStatus: BottleStatus.filledAtReseller),
                        ColorsConstants.orangeColor),
                    Utils.builActionsPagedWidget(
                        "Scanner des bouteilles vides reçues",
                        ResellerDoubleScanPage(
                            targetStatus: BottleStatus.emptyAtReseller),
                        ColorsConstants.greenColor),
                    Utils.builActionsPagedWidget(
                        "Vendre une bouteille",
                        ResellerDoubleScanPage(
                            targetStatus: BottleStatus.filledAtClient),
                        ColorsConstants.greenColor),
                    Utils.builActionsPagedWidget(
                        "Scanner des bouteilles vides prêtes à être livrées",
                        ResellerScanPage(
                            targetStatus: BottleStatus.emptyAtMarketer),
                        ColorsConstants.orangeColor)
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
/*
,

 */
