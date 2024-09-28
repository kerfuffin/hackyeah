import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:achievo/main_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achievo',
      theme: flutterNesTheme(),
      home: const MainApp(),
    );
  }
}


