import 'package:flutter/material.dart';
import 'package:gazpourtous/layouts/default/pages/bottlesListPage.dart';
import 'package:gazpourtous/layouts/default/pages/scanPage.dart';
import 'package:gazpourtous/layouts/filler/pages/fillerActionsPage.dart';
import 'package:gazpourtous/layouts/filler/pages/fillerSettingsPage.dart';
import 'package:get/get.dart';

class FillerLayout extends StatefulWidget {
  const FillerLayout({super.key});

  @override
  State<FillerLayout> createState() => _FillerLayoutState();
}

class _FillerLayoutState extends State<FillerLayout> {
  List<Widget> _pages = <Widget>[
    FillerActionsPage(),
    BottlesListPage(),
    FillerSettingsPage()
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
