import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedImageSequence extends StatefulWidget {
  final String animationName;  // Nazwa animacji (np. "skeleton")
  final String initialState;   // Początkowy stan animacji (np. "idle")
  final List<String> availableStates; // Lista dostępnych stanów (np. ["idle", "walk", "run"])
  final Map<String, List<String>> frames; // Mapowanie stanów na listy plików PNG

  const AnimatedImageSequence({
    required this.animationName,
    required this.initialState,
    required this.availableStates,
    required this.frames, // Każdy stan zawiera listę ścieżek do obrazów
  });

  @override
  _AnimatedImageSequenceState createState() => _AnimatedImageSequenceState();
}

class _AnimatedImageSequenceState extends State<AnimatedImageSequence> {
  int _currentFrame = 0;
  late Timer _timer;
  String currentState = '';

  @override
  void initState() {
    super.initState();
    currentState = widget.initialState;
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _currentFrame = (_currentFrame + 1) % widget.frames[currentState]!.length;
      });
    });
  }

  void _swapState() {
    // Zatrzymaj bieżący timer
    _timer.cancel();
    
    setState(() {
      // Zmień stan na następny
      int currentIndex = widget.availableStates.indexOf(currentState);
      int nextIndex = (currentIndex + 1) % widget.availableStates.length;
      currentState = widget.availableStates[nextIndex];

      _currentFrame = 0; // Zresetuj ramkę

      // Uruchom animację dla nowego stanu
      _startAnimation();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.frames[currentState]!.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Image.asset(widget.frames[currentState]![_currentFrame]),
              ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _swapState,
          child: Text("Swap State"),
        ),
      ],
    );
  }
}