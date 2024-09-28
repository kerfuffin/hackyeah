import 'package:achievo/animation.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'dart:async';

void main() {
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
    );
  }
}
