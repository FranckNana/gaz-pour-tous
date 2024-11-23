import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/layouts/customer/pages/customerSettingsPage.dart';
import 'package:gazpourtous/layouts/default/pages/bottlesListPage.dart';
import 'package:gazpourtous/layouts/default/pages/qRCodePage.dart';

class CustomerLayout extends StatefulWidget {
  const CustomerLayout({super.key});

  @override
  State<CustomerLayout> createState() => _CustomerLayoutState();
}

class _CustomerLayoutState extends State<CustomerLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = <Widget>[
    QRCodePage(),
    BottlesListPage(),
    CustomerSettingsPage()
  ];

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
              icon: Icon(Icons.qr_code_2), label: "Mon QR code"),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Mes bouteilles"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Paramètres")
        ],
        currentIndex: _currentIndex,
        onTap: _onBottomTaped,
      ),
    );
  }

  _onBottomTaped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
