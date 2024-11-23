import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static Widget builActionsPagedWidget(
      String label, Widget widget, Color color) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 100,
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color.withOpacity(.7),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: color)),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      onTap: () => Get.to(() => widget),
    );
  }

  static Widget getProfileChip(String profile) {
    return Chip(label: Text(profile));
  }
}
