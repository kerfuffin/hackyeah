import 'package:achievo/animation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nes_ui/nes_ui.dart';
import 'package:achievo/main_app.dart';
import 'package:achievo/views/name_page.dart';
import 'package:achievo/views/google_login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/home_page.dart';

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
    // Tworzymy StreamController
    final StreamController<String> stateController = StreamController<String>();

    return MaterialApp(
      title: 'Achievo',
      theme: flutterNesTheme(),
      home: Column(
        children: [
          AnimatedImageSequence(
            animationName: 'skeleton',
            initialState: 'idle',
            availableStates: ['idle', 'attack'],
            stateController: stateController, // Przekazujemy kontroler
            size: 300,
          ),
          ElevatedButton(
            onPressed: () {
              // Zamiana stanu animacji
              stateController.add('attack');
            },
            child: Text('Przejdź do ataku'),
          ),
          ElevatedButton(
            onPressed: () {
              // Zamiana stanu animacji z powrotem do 'idle'
              stateController.add('idle');
            },
            child: Text('Przejdź do idle'),
          ),
        ],
      ),
      routes: <String, WidgetBuilder>{
        '/name': (BuildContext context) => const NamePage(),
        '/home': (BuildContext context) => const HomePage(),
        '/login': (BuildContext context) => GoogleSignInButton(),
      },
    );
  }
}
