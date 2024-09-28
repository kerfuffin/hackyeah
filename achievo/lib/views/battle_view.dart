import 'package:flutter/material.dart';

class BattleView extends StatelessWidget {
  final String backgroundImagePath;
  final String characterImagePath;
  final String enemyImagePath;
  final double enemyHealth; // Current health for the enemy
  final double maxEnemyHealth; // Max health for the enemy
  final VoidCallback onAbandon; // Callback function for the abandon button

  const BattleView({
    Key? key,
    required this.backgroundImagePath,
    required this.characterImagePath,
    required this.enemyImagePath,
    required this.enemyHealth,
    required this.maxEnemyHealth,
    required this.onAbandon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Center(
                child: Text(
                  'Enemy name',
                  style: TextStyle(color: Colors.red, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10), // Spacing between name and progress bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20), // Add left and right space
                height: 10,
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
          bottom: 60, // Adjust as needed
          left: 20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 3),
            ),
            child: Image.asset(characterImagePath, fit: BoxFit.cover),
          ),
        ),
        // Enemy area (red)
        Positioned(
          bottom: 60, // Adjust as needed
          right: 20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 3),
            ),
            child: Image.asset(enemyImagePath, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
