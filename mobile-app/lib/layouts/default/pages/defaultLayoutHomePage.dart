import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/default/pages/loginScanPage.dart';
import 'package:get/get.dart';

class DefaultLayoutHomePage extends StatelessWidget {
  const DefaultLayoutHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Get.height * .50,
              child: Column(
                children: [
                  Flexible(child: Image.asset("assets/images/logo.png")),
                  const Text(
                    "Bienvenue",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  const Text(
                    "Veuillez sélectionner votre profil",
                    style: TextStyle(fontSize: 25),
                  )
                ],
              ),
            ),
            Container(
              height: Get.height * .50,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsConstants.orangeColor),
                    child: Container(
                      alignment: Alignment.center,
                      color: ColorsConstants.orangeColor,
                      child: const Text(
                        "Je suis client",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                    onPressed: () => Get.to(
                        () => const LoginScanPage(profile: Profile.client)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsConstants.greenColor),
                    onPressed: () => Get.to(
                        () => const LoginScanPage(profile: Profile.revendeur)),
                    child: Container(
                      alignment: Alignment.center,
                      color: ColorsConstants.greenColor,
                      child: const Text("Je suis revendeur",
                          style: TextStyle(color: Colors.white, fontSize: 17)),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsConstants.orangeColor),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text("Je suis emplisseur",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                      ),
                      onPressed: () => Get.to(() =>
                          const LoginScanPage(profile: Profile.emplisseur))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsConstants.greenColor),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text("Je suis marketeur",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                      ),
                      onPressed: () => Get.to(() =>
                          const LoginScanPage(profile: Profile.marketeur)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
