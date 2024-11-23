import 'package:flutter/material.dart';
import 'package:gazpourtous/bindings.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/controllers/appController.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/customer/customerLayout.dart';
import 'package:gazpourtous/layouts/default/pages/defaultLayoutHomePage.dart';
import 'package:gazpourtous/layouts/filler/fillerLayout.dart';
import 'package:gazpourtous/layouts/marketer/marketerLayout.dart';
import 'package:get/get.dart';

class GazPourTousApp extends StatelessWidget {
  GazPourTousApp({super.key});

  late final AppController _appController;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBindings(),
      onInit: () {
        _appController = Get.find();
      },
      home: Obx(() {
        if (_appController.loginStatus.value == LoginStatus.loggedIn) {
          if (_appController.profile.value == Profile.client) {
            return CustomerLayout();
          } else if (_appController.profile.value == Profile.emplisseur) {
            return FillerLayout();
          } else if (_appController.profile.value == Profile.marketeur) {
            return MarketerLayout();
          } else {
            return Placeholder();
          }
        } else if (_appController.loginStatus.value == LoginStatus.loading) {
          return Container(
            child: Center(
                child: CircularProgressIndicator(
              color: ColorsConstants.orangeColor,
            )),
          );
        } else {
          return DefaultLayoutHomePage();
        }
      }),
    );
  }
}
