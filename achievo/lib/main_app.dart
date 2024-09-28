// create main app

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:achievo/views/google_login_view.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // First cloud layer
        Positioned.fill(
          child: Image.asset(
            'assets/images/cloud_1.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Image.asset(
            'assets/images/cloud_2.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Image.asset(
            'assets/images/cloud_3.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Image.asset(
            'assets/images/cloud_4.png',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Welcome to Achievo",
                      style: Theme.of(context).textTheme.displayLarge)
                  .animate()
                  .fadeIn(
                    duration: const Duration(seconds: 3),
                    curve: Curves.easeIn,
                  ),
              const SizedBox(height: 20),
              // wait for 3 seconds, then show google button
              GoogleSignInScreen()
            ],
          ),
        )
      ],
    );
  }
}
