// create main app

import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';


class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievo'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Achievo',
            ),
          ],
        ),
      ),
    );
  }
}
