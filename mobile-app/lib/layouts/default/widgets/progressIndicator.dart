import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';

class GPTProgressindicator extends StatelessWidget {
  const GPTProgressindicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator(
      color: ColorsConstants.orangeColor,
    ));
  }
}
