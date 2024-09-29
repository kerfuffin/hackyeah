import 'dart:async';

import 'package:achievo/animation.dart';
import 'package:flutter/material.dart';

class BattleView extends StatelessWidget {
  final String backgroundImagePath;
  final String characterImagePath;
  final String enemyImagePath;
  final double enemyHealth; // Current health for the enemy
  final double maxEnemyHealth; // Max health for the enemy
  final double timeLeft; // Time left for the action
  final double maxTime; // Max time for the action
  final VoidCallback onAbandon; // Callback function for the abandon button

  const BattleView({
    Key? key,
    required this.backgroundImagePath,
    required this.characterImagePath,
    required this.enemyImagePath,
    required this.enemyHealth,
    required this.maxEnemyHealth,
    required this.timeLeft,
    required this.maxTime,
    required this.onAbandon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StreamController<String> enemyStateController = StreamController<String>();
    final StreamController<String> characterStateController = StreamController<String>();

    return Stack(
      children: [
        // Background Image
        ClipRect(
          child: Image.asset(
            backgroundImagePath,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.none,
          ),
        ),
        // Overlay content
        Positioned(
          top: 30, // Adjusted to move the button up
          left: MediaQuery.of(context).size.width * 0.05, // Adjusted to move the button to the left
          child: ElevatedButton(
            onPressed: onAbandon, // Call the function passed to the button
            child: const Text(
              'Abandon',
              style: TextStyle(color: Colors.red),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
              backgroundColor: Colors.white, // Text color
            ),
          ),
        ),
        Positioned(
          top: 100, // Adjust as needed
          left: 0, // Align to the left side
          right: 0, // Align to the right side
          child: Column(
            children: [
              // Label for Time Left
              Text(
                'Time Left',
                style: TextStyle(color: const Color.fromARGB(255, 28, 236, 243), fontSize: 16), // Smaller than enemy name text
              ),
              // Progress bar for time left
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20), // Add left and right space
                height: 5, // Made thinner
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: LinearProgressIndicator(
                  value: timeLeft / maxTime,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                      const Color.fromARGB(2255, 28, 236, 243)),
                ),
              ),
              // Text for time left
              Text(
                '${timeLeft.toInt()}',
                style: TextStyle(color: Color.fromARGB(2255, 28, 236, 243), fontSize: 16),
              ),
              const SizedBox(height: 10), // Spacing between progress bars
              Center(
                child: Text(
                  'Enemy name',
                  style: TextStyle(color: Colors.red, fontSize: 24), // Enemy name text
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10), // Spacing between name and health progress bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20), // Add left and right space
                height: 10, // Original height for health bar
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: LinearProgressIndicator(
                  value: enemyHealth / maxEnemyHealth,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                      const Color.fromARGB(255, 243, 47, 33)),
                ),
              ),
              const SizedBox(height: 5), // Spacing for health values
              Text(
                '${enemyHealth.toInt()} / ${maxEnemyHealth.toInt()}',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
          ),
        ),
        // Character area (green)
        Positioned(
          bottom: 55, // Adjust as needed
          left: 10,
          child: Container(
            child: AnimatedImageSequence(
              animationName: 'dude',
              initialState: 'idle',
              stateTypes: {
                'idle': 0,  // Pętla
              },
              stateTransitions: {
                //'attack': 'idle',  // Po "attack" przejdź do "idle"
              },
              stateController: characterStateController, // Przekazujemy kontroler
              size: 150,
              animSpeed: 300,
            ),
          ),
        ),
        // Enemy area (red)
        Positioned(
          bottom: 55, // Adjust as needed
          right: 0,
          child: Container(
            //decoration: BoxDecoration(
              //border: Border.all(color: Colors.red, width: 3),
            //),
            child:  AnimatedImageSequence(
              animationName: 'centipede',
              initialState: 'idle',
              stateTypes: {
                'idle': 0,  // Pętla
              },
              stateTransitions: {
                //'attack': 'idle',  // Po "attack" przejdź do "idle"
              },
              stateController: enemyStateController, // Przekazujemy kontroler
              size: 200,
              animSpeed: 200,
            ),
          ),
        ),
      ],
    );
  }
}
