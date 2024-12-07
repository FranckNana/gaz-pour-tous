import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/layouts/default/pages/bottlesListPage.dart';
import 'package:gazpourtous/layouts/default/pages/qRCodePage.dart';
import 'package:gazpourtous/layouts/reseller/pages/resellerActionsPage.dart';
import 'package:gazpourtous/layouts/reseller/pages/resellerSettingsPage.dart';

class ResellerLayout extends StatefulWidget {
  const ResellerLayout({super.key});

  @override
  State<ResellerLayout> createState() => _ResellerLayoutState();
}

class _ResellerLayoutState extends State<ResellerLayout> {
  final List<Widget> _pages = <Widget>[
    const ResellerActionsPage(),
    BottlesListPage(),
    QRCodePage(),
    ResellerSettingsPage()
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
              icon: Icon(Icons.qr_code_scanner), label: "Actions"),
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
