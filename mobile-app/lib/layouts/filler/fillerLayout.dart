import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/layouts/default/pages/bottlesListPage.dart';
import 'package:gazpourtous/layouts/default/pages/qRCodePage.dart';
import 'package:gazpourtous/layouts/filler/pages/fillerActionsPage.dart';
import 'package:gazpourtous/layouts/filler/pages/fillerSettingsPage.dart';

class FillerLayout extends StatefulWidget {
  const FillerLayout({super.key});

  @override
  State<FillerLayout> createState() => _FillerLayoutState();
}

class _FillerLayoutState extends State<FillerLayout> {
  final List<Widget> _pages = <Widget>[
    const FillerActionsPage(),
    BottlesListPage(),
    QRCodePage(),
    FillerSettingsPage()
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_currentIndex),
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
              icon: Icon(Icons.qr_code), label: "Mon QR code"),
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
