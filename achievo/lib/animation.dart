import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AnimatedImageSequence extends StatefulWidget {
  final String animationName;  // Nazwa animacji (np. "skeleton")
  final String initialState;   // Początkowy stan animacji (np. "idle")
  final List<String> availableStates; // Lista dostępnych stanów (np. ["idle", "attack"])
  final double? size; // Opcjonalna wielkość animacji

  const AnimatedImageSequence({
    Key? key,
    required this.animationName,
    required this.initialState,
    required this.availableStates,
    this.size,
  }) : super(key: key);

  @override
  _AnimatedImageSequenceState createState() => _AnimatedImageSequenceState();

  // Nowa metoda do ustawiania stanu z zewnątrz
  static _AnimatedImageSequenceState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AnimatedImageSequenceState>();
  }

  void setStateFromOutside(BuildContext context, String newState) {
    final state = of(context);
    if (state != null && availableStates.contains(newState)) {
      state.setStateFromOutside(newState);
    }
  }
}

class _AnimatedImageSequenceState extends State<AnimatedImageSequence> {
  int _currentFrame = 0;
  late Timer _timer;
  String currentState = '';
  Map<String, List<String>> frames = {};

  @override
  void initState() {
    super.initState();
    currentState = widget.initialState;
    _loadFrames().then((_) {
      _startAnimation();
    });
  }

  Future<void> _loadFrames() async {
    final basePath = 'animations/${widget.animationName}/';
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    for (String state in widget.availableStates) {
      String statePath = '$basePath$state/';
      List<String> stateFrames = manifestMap.keys
          .where((String key) => key.startsWith(statePath) && key.endsWith('.png'))
          .toList();

      stateFrames.sort();
      print('Wczytano ${stateFrames.length} klatek dla stanu $state');
      frames[state] = stateFrames;
    }

    setState(() {});
  }

  void _startAnimation() {
    if (frames[currentState] == null || frames[currentState]!.isEmpty) return;
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _currentFrame = (_currentFrame + 1) % frames[currentState]!.length;
      });
    });
  }

  void setStateFromOutside(String newState) {
    _timer.cancel();
    setState(() {
      currentState = newState;
      _currentFrame = 0;
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
    return Container(
      width: widget.size, // Ustawienie szerokości kontenera
      height: widget.size, // Ustawienie wysokości kontenera
      alignment: Alignment.center, // Wyśrodkowanie obrazu
      child: frames.isEmpty || frames[currentState] == null || frames[currentState]!.isEmpty
          ? CircularProgressIndicator()
          : Image.asset(
              frames[currentState]![_currentFrame],
              fit: BoxFit.contain,
              width: widget.size,
              height: widget.size,
              filterQuality: FilterQuality.none,
            ),
    );
  }
}
