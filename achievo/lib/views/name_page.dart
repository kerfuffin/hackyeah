import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    // textarea to enter name
    // button to continue, with animations
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Enter your name", style: Theme.of(context).textTheme.displayLarge)
            .animate()
            .fadeIn(
              duration: const Duration(seconds: 3),
              curve: Curves.easeIn,
            ),
            const SizedBox(height: 20),
            //textarea with padding and smaller width
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                width: 200,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            //button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
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