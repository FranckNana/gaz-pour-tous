import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/layouts/default/pages/bottlesListPage.dart';
import 'package:gazpourtous/layouts/default/pages/qRCodePage.dart';
import 'package:gazpourtous/layouts/marketer/pages/marketerActionsPage.dart';
import 'package:gazpourtous/layouts/marketer/pages/marketerSettingsPage.dart';

class MarketerLayout extends StatefulWidget {
  const MarketerLayout({super.key});

  @override
  State<MarketerLayout> createState() => _MarketerLayoutState();
}

class _MarketerLayoutState extends State<MarketerLayout> {
  final List<Widget> _pages = <Widget>[
    MarketerActionsPage(),
    BottlesListPage(),
    QRCodePage(),
    MarketterSettingsPage()
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: ColorsConstants.orangeColor,
        unselectedItemColor: Colors.blueGrey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_outlined), label: "Actions"),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined), label: "Mes bouteilles"),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_2), label: "Mon QR code"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Paramètres")
        ],
        currentIndex: _currentIndex,
        onTap: _onNavigationBarTaped,
      ),
    );
  }

  _onNavigationBarTaped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
