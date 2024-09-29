import 'package:achievo/animation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nes_ui/nes_ui.dart';
import 'package:achievo/main_app.dart';
import 'package:achievo/views/name_page.dart';
import 'package:achievo/views/google_login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'views/home_page.dart';
import 'views/google_login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Achievo',
      theme: flutterNesTheme(),
      home: const HomePage(),
      routes: <String, WidgetBuilder>{
        '/name': (BuildContext context) => const NamePage(),
        '/home': (BuildContext context) => const HomePage(),
        '/login': (BuildContext context) => GoogleSignInScreen(),
      },
    );
  }
}
