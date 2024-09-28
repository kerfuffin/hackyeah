import 'package:achievo/animation.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:achievo/main_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const AnimatedImageSequence animatedImageSequence = AnimatedImageSequence(
          animationName: 'skeleton',
          initialState: 'idle',
          availableStates: ['idle', 'attack'],
          size: 300,
        );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achievo',
      theme: flutterNesTheme(),
      //home: const MainApp(),
      home: Column(
      children: [
        animatedImageSequence,
        ElevatedButton(
          onPressed: () {
            AnimatedImageSequence.of(context)?.setStateFromOutside('attack');
          },
          child: Text('Przejdź do ataku'),
        ),
      ],
      )
    );
  }
}


