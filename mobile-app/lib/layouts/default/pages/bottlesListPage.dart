import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/controllers/bottlesController.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BottlesListPage extends StatelessWidget {
  BottlesListPage({super.key});

  final BottlesController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.orangeColor,
        title: const Text("Liste des bouteilles"),
        actions: [
          IconButton(
            onPressed: () => _controller.getBottles(),
            icon: const Icon(Icons.refresh_outlined),
          )
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: ColorsConstants.orangeColor,
            ),
          );
        } else if (!_controller.isLoading.value &&
            _controller.bottles.isNotEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
                itemCount: _controller.bottles.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorsConstants.orangeColor),
                        color: ColorsConstants.orangeColor.withOpacity(.1),
                        borderRadius: BorderRadius.circular(7)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text("Référence"),
                                Text(
                                    "${_controller.bottles.elementAt(index).bottleId}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorsConstants.orangeColor))
                              ],
                            ),
                            Column(
                              children: [
                                Text("Statut"),
                                Text(
                                  "${_controller.bottles.elementAt(index).state}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorsConstants.orangeColor),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text("Capacité"),
                                Text(
                                  "${_controller.bottles.elementAt(index).capacity} kg",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorsConstants.orangeColor),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Date modification"),
                                _controller.bottles
                                            .elementAt(index)
                                            .last_update !=
                                        null
                                    ? Text(
                                        DateFormat('dd-MM-yyyy HH:mm').format(
                                            _controller.bottles
                                                .elementAt(index)
                                                .last_update!),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ColorsConstants.orangeColor),
                                      )
                                    : const Text("N/A")
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: const Text("Aucune bouteille"),
          );
        }
      }),
    );
  }
}
