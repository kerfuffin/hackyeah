import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AnimatedImageSequence extends StatefulWidget {
  final String animationName;
  final String initialState;
  final List<String> availableStates;
  final double? size;
  final StreamController<String> stateController;
  final int animSpeed;

  const AnimatedImageSequence({
    Key? key,
    required this.animationName,
    required this.initialState,
    required this.availableStates,
    required this.stateController,
    required this.animSpeed,

    this.size,
  }) : super(key: key);

  @override
  _AnimatedImageSequenceState createState() => _AnimatedImageSequenceState();
}

class _AnimatedImageSequenceState extends State<AnimatedImageSequence> {
  int _currentFrame = 0;
  late Timer _timer;
  String currentState = '';
  Map<String, List<String>> frames = {};
  
  // Flaga, czy wszystkie klatki zostały załadowane
  bool areFramesFullyLoaded = false;

  @override
  void initState() {
    super.initState();
    currentState = widget.initialState;

    // Ładujemy i cache'ujemy wszystkie klatki na starcie
    _loadAndCacheAllFrames().then((_) {
      setState(() {
        areFramesFullyLoaded = true; // Wszystkie klatki są gotowe
        _startAnimation(); // Dopiero teraz startujemy animację
      });
    });

    // Nasłuchujemy zmian stanu
    widget.stateController.stream.listen((newState) {
      if (areFramesFullyLoaded) {
        _swapState(newState);
      }
    });
  }

  Future<void> _loadAndCacheAllFrames() async {
    final basePath = 'animations/${widget.animationName}/';
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    for (String state in widget.availableStates) {
      String statePath = '$basePath$state/';
      List<String> stateFrames = manifestMap.keys
          .where((String key) => key.startsWith(statePath) && key.endsWith('.png'))
          .toList();

      stateFrames.sort();
      frames[state] = stateFrames;

      // Cache'owanie obrazów
      for (String frame in stateFrames) {
        await _cacheImage(frame);
      }
      print('Wczytano i zcache\'owano ${stateFrames.length} klatek dla stanu $state');
    }
  }

  Future<void> _cacheImage(String assetPath) async {
    // Ładujemy obraz z assets i cache'ujemy go
    final ImageStream stream = AssetImage(assetPath).resolve(const ImageConfiguration());
    final Completer<void> completer = Completer<void>();
    final ImageStreamListener listener = ImageStreamListener((_, __) {
      completer.complete();
    }, onError: (dynamic exception, StackTrace? stackTrace) {
      completer.completeError(exception, stackTrace);
    });
    stream.addListener(listener);
    await completer.future;
    stream.removeListener(listener);
  }

  void _startAnimation() {
    if (frames[currentState] == null || frames[currentState]!.isEmpty) return;
    _timer = Timer.periodic(Duration(milliseconds: widget.animSpeed), (timer) {
      setState(() {
        _currentFrame = (_currentFrame + 1) % frames[currentState]!.length;
      });
    });
  }

  void _swapState(String newState) {
    if (widget.availableStates.contains(newState) && newState != currentState) {
      // Zatrzymaj aktualną animację
      _timer.cancel();

      // Zmień stan i zresetuj klatkę
      setState(() {
        currentState = newState;
        _currentFrame = 0; // Resetujemy klatkę
      });

      // Uruchamiamy nową animację
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      width: widget.size,
      height: widget.size,
      alignment: Alignment.center,
      child: !areFramesFullyLoaded
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
