import 'package:achievo/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:achievo/main_app.dart';
import 'package:achievo/views/name_page.dart';
import 'package:achievo/views/google_login_view.dart';

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
      routes: <String, WidgetBuilder>{
        '/name': (BuildContext context) => const NamePage(),
        '/home': (BuildContext context) => const HomePage(),
        '/login': (BuildContext context) => GoogleSignInScreen(),
      },
    );
  }
}


