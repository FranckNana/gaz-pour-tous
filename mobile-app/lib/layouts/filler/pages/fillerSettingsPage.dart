import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/controllers/appController.dart';
import 'package:get/get.dart';

class FillerSettingsPage extends StatelessWidget {
  FillerSettingsPage({super.key});

  final AppController _appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.orangeColor,
        title: Text("Paramètres"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Déconnexion"),
            leading: Icon(Icons.logout_outlined),
            onTap: () => _appController.logout(),
          )
        ],
      ),
    );
  }
}
