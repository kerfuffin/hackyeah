import 'package:achievo/animation.dart';
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
      //home: const MainApp(),
      home: AnimatedImageSequence(
          animationName: 'skeleton', // Nazwa animacji
          initialState: 'idle',      // Początkowy stan
          availableStates: ['idle', 'attack'], // Dostępne stany
          frames: {
            // Przekazujemy listy plików PNG dla każdego stanu
            'idle': [
              'animations/skeleton/idle/frame_1.png',
              'animations/skeleton/idle/frame_2.png',
              'animations/skeleton/idle/frame_3.png',
              'animations/skeleton/idle/frame_4.png',
            ],
            'attack': [
              'animations/skeleton/attack/frame_1.png',
              'animations/skeleton/attack/frame_2.png',
              'animations/skeleton/attack/frame_3.png',
              'animations/skeleton/attack/frame_4.png',
              'animations/skeleton/attack/frame_5.png',
              'animations/skeleton/attack/frame_6.png',
            ],
          },
        ),
    );
  }
}


