import 'package:flutter/material.dart';

class CustomerBottomMenuBar extends StatelessWidget {
  CustomerBottomMenuBar(
      {super.key, required int selectedIndex, required this.onTap});

  final ValueSetter<int> onTap;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: "Mes bouteilles"),
        BottomNavigationBarItem(
            icon: Icon(Icons.history), label: "Mon code QR"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Paramètres")
      ],
      currentIndex: selectedIndex,
      onTap: onTap,
    );
  }
}
