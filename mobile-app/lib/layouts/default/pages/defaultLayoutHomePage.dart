import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/controllers/appController.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/default/pages/loginScanPage.dart';
import 'package:get/get.dart';

class DefaultLayoutHomePage extends StatelessWidget {
  DefaultLayoutHomePage({super.key});

  final AppController _appController = Get.find();

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
                  Flexible(child: Image.asset("assets/images/logo.jpeg")),
                  Text(
                    "Bienvenue",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  Text(
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
                      child: Text(
                        "Je suis client",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      alignment: Alignment.center,
                      color: ColorsConstants.orangeColor,
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
                      child: Text("Je suis revendeur",
                          style: TextStyle(color: Colors.white, fontSize: 17)),
                      alignment: Alignment.center,
                      color: ColorsConstants.greenColor,
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsConstants.orangeColor),
                      child: Container(
                        child: Text("Je suis emplisseur",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                        alignment: Alignment.center,
                      ),
                      onPressed: () => Get.to(
                          () => LoginScanPage(profile: Profile.emplisseur))),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsConstants.greenColor),
                    child: Container(
                      child: Text("Je suis transporteur",
                          style: TextStyle(color: Colors.white, fontSize: 17)),
                      alignment: Alignment.center,
                    ),
                    onPressed: () => {},
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsConstants.orangeColor),
                      child: Container(
                        child: Text("Je suis marketeur",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                        alignment: Alignment.center,
                      ),
                      onPressed: () => Get.to(
                          () => LoginScanPage(profile: Profile.marketeur)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
