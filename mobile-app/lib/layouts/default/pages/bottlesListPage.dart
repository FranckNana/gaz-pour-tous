import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/controllers/bottlesController.dart';
import 'package:get/get.dart';

class BottlesListPage extends StatelessWidget {
  BottlesListPage({super.key});

  final BottlesController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.orangeColor,
        title: const Text("Liste des bouteilles"),
      ),
      body: Obx(() {
        if (!_controller.isLoading.value && _controller.bottles.isNotEmpty) {
          return ListView.builder(
              itemCount: _controller.bottles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      "Référence: ${_controller.bottles.elementAt(index).bottleId}"),
                  trailing: Text(
                      "Statut: ${_controller.bottles.elementAt(index).state}"),
                );
              });
        } else {
          return Container(
            alignment: Alignment.center,
            child: Text("Aucune bouteille"),
          );
        }
      }),
    );
  }
}
