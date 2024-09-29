import 'dart:async';
import 'package:achievo/animation.dart';
import 'package:achievo/views/quest_list.dart';
import 'package:flutter/material.dart';

class BattleView extends StatefulWidget {
  final Quest quest; // The quest being passed

  const BattleView({
    Key? key,
    required this.quest,
  }) : super(key: key);

  @override
  _BattleViewState createState() => _BattleViewState();
}

class _BattleViewState extends State<BattleView> {
  late int timeLeft;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    timeLeft = widget.quest.timeLimit.inSeconds; // Initialize time left from quest's time limit
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--; // Decrease time left by 1 second
        });
      } else {
        _timer.cancel(); // Stop the timer when it reaches 0
        // Handle quest completion or failure here
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer if the widget is disposed
    super.dispose();
  }

  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secs = seconds % 60;
    return '$hours hr ${minutes.toString().padLeft(2, '0')} min ${secs.toString().padLeft(2, '0')} sec';
  }

  @override
  Widget build(BuildContext context) {
    final StreamController<String> enemyStateController = StreamController<String>();
    final StreamController<String> characterStateController = StreamController<String>();

    final String backgroundImagePath = 'assets/images/Background.png';
    final int maxTime = widget.quest.timeLimit.inSeconds;
    final int enemyHealth = 500;
    final int maxEnemyHealth = 700;

    return Scaffold( // Wrap the content in a Scaffold
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            backgroundImagePath,
            fit: BoxFit.cover, // Cover the entire screen
            width: double.infinity, // Ensure it fills horizontally
            height: double.infinity, // Ensure it fills vertically
            filterQuality: FilterQuality.none,
          ),
          // Overlay content
          Positioned(
            top: 30,
            left: MediaQuery.of(context).size.width * 0.05,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(), // Abandon action
              child: const Text(
                'Abandon',
                style: TextStyle(color: Colors.red),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Time Left label and progress bar
                const Text('Time Left', style: TextStyle(color: Color(0xFF1CECF3), fontSize: 16)),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: LinearProgressIndicator(
                    value: timeLeft / maxTime,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1CECF3)),
                  ),
                ),
                Text(_formatTime(timeLeft), style: const TextStyle(color: Color(0xFF1CECF3), fontSize: 16)),
                const SizedBox(height: 10),
                // Enemy name and health bar
                Center(
                  child: Text(
                    widget.quest.name, // Display quest name as enemy name
                    style: const TextStyle(color: Colors.red, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: LinearProgressIndicator(
                    value: enemyHealth / maxEnemyHealth,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFF32F21)),
                  ),
                ),
                const SizedBox(height: 5),
                Text('${enemyHealth.toInt()} / ${maxEnemyHealth.toInt()} HP', style: const TextStyle(color: Colors.red, fontSize: 16)),
              ],
            ),
          ),
          // Character area (left side)
          Positioned(
            bottom: 55,
            left: 10,
            child: AnimatedImageSequence(
              animationName: 'dude',
              initialState: 'idle',
              stateTypes: {
                'idle': 0,
              },
              stateTransitions: {},
              stateController: characterStateController,
              size: 150,
              animSpeed: 300,
            ),
          ),
          // Enemy area (right side)
          Positioned(
            bottom: 55,
            right: 0,
            child: AnimatedImageSequence(
              animationName: 'centipede',
              initialState: 'idle',
              stateTypes: {
                'idle': 0,
              },
              stateTransitions: {},
              stateController: enemyStateController,
              size: 200,
              animSpeed: 200,
            ),
          ),
        ],
      ),
    );
  }
}
