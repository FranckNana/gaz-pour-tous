import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gazpourtous/GazPourTousApp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(GazPourTousApp());
}
