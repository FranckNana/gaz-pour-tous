import 'package:flutter/material.dart';
import 'package:gazpourtous/layouts/default/pages/bottlesListPage.dart';
import 'package:gazpourtous/layouts/default/pages/scanPage.dart';
import 'package:gazpourtous/layouts/marketer/pages/marketerActionsPage.dart';
import 'package:gazpourtous/layouts/marketer/pages/marketerSettingsPage.dart';
import 'package:get/get.dart';

class MarketerLayout extends StatefulWidget {
  const MarketerLayout({super.key});

  @override
  State<MarketerLayout> createState() => _MarketerLayoutState();
}

class _MarketerLayoutState extends State<MarketerLayout> {
  List<Widget> _pages = <Widget>[
    MarketerActionsPage(),
    BottlesListPage(),
    MarketterSettingsPage()
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(children: _pages, index: _currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: "Actions"),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined), label: "Mes bouteilles"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Paramètres")
        ],
        currentIndex: _currentIndex,
        onTap: _onNavigationBarTaped,
      ),
    );
  }

  onNavigateToQRScan() async {
    String code = await Get.to(ScanPage());
    Get.snackbar("code", "$code");
  }

  _onNavigationBarTaped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
