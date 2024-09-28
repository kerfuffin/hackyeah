// create main app

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:newton_particles/newton_particles.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Welcome to Achievo", style: Theme.of(context).textTheme.displayLarge)
            .animate()
            .fadeIn(
              duration: const Duration(seconds: 3),
              curve: Curves.easeIn,
            ),
            const SizedBox(height: 20),
            //button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/name');
              },
              child: const Text('Continue'),
            ).animate()
            .fadeIn(
              duration: const Duration(seconds: 3),
              curve: Curves.easeIn,
            ),
          ],
        ),
      ),
    );
  }
}
