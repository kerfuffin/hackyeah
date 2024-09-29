import 'package:achievo/views/battle_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'stats_table.dart';
import 'quest_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences prefs;
  int _currentIndex = 0;

  late final List<Widget> _views; 

  final Widget _quests = Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/quest_board.png'), // Replace with your image path
      fit: BoxFit.cover, // Adjust the image to cover the entire container
      filterQuality: FilterQuality.none,
    ),
  ),
  child: QuestList(
    initialQuests: [
      Quest(
        name: 'Quest 1',
        iconPath: 'assets/images/questIcons/Icons_21.png',
        experience: 100,
        gold: 50,
        objectives: '2000 steps',
        timeLimit: Duration(hours: 1),
        level: 'easy',
        enemy: 'centipede',
      ),
      Quest(
        name: 'Quest 2',
        iconPath: 'assets/images/questIcons/Icons_22.png',
        experience: 200,
        gold: 100,
        objectives: '5 km',
        timeLimit: Duration(hours: 2),
        level: 'hard',
        enemy: 'centipede',
      ),
      Quest(
        name: 'Quest 3',
        iconPath: 'assets/images/questIcons/Icons_23.png',
        experience: 300,
        gold: 20,
        objectives: '200 kcal',
        timeLimit: Duration(minutes: 90),
        level: 'hard',
        enemy: 'centipede',
      ),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _initializeViews(); 
  }

  void _initializeViews() {
    _views = [
      _quests
    ];
  }

  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievo'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: IndexedStack(
              index: _currentIndex,
              children: _views,
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/paper_bg.png'),
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.none,
                ),
              ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAbandon() {
    print('Abandon battle');
  }
}
