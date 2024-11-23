import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.orangeColor,
        title: Text("Mes bouteilles"),
      ),
      body: Container(
        color: Colors.orange,
        child: Text("Mes bouteilles"),
      ),
    );
  }
}
