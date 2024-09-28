import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'stats_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        body: Column(
          children: <Widget>[
            Expanded(
                flex: 7,
                child: Container(
                  color: const Color.fromARGB(255, 116, 46, 0),
                )),
            Expanded(
              flex: 3,
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/stat_bg.png'),
                    fit: BoxFit.fill,
                  )),
                  child: StatsTable(
                    initialStats: [
                      Stat(
                        name: 'STR',
                        value: 10,
                        backgroundColor: Colors.red,
                      ),
                      Stat(
                        name: 'DEX',
                        value: 10,
                        backgroundColor: Colors.green,
                      ),
                      Stat(
                        name: 'INT',
                        value: 10,
                        backgroundColor: Colors.blue,
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
