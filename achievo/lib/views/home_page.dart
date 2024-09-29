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

  late Widget _quest;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _initializeViews(); 
  }

  void _initializeViews() {
    this._quest = Container(
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
            name: 'Giant Centipede',
            iconPath: 'assets/images/questIcons/Icons_37.png',
            experience: 150,
            gold: 70,
            objectives: '2500 steps',
            timeLimit: Duration(hours: 1),
            level: 'medium',
            enemy: 'centipede',
          ),
          Quest(
            name: 'Spider Slayer',
            iconPath: 'assets/images/questIcons/Icons_22.png',
            experience: 200,
            gold: 100,
            objectives: '5 km',
            timeLimit: Duration(hours: 2),
            level: 'hard',
            enemy: 'centipede',
          ),
          Quest(
            name: "Toad's Bane",
            iconPath: 'assets/images/questIcons/Icons_23.png',
            experience: 300,
            gold: 20,
            objectives: '200 kcal',
            timeLimit: Duration(minutes: 90),
            level: 'hard',
            enemy: 'centipede',
          ),
          ],
          onQuestCompleted: _goOnQuest,
        ),
      );

    _views = [
      _quest
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
                    backgroundColor: const Color.fromARGB(255, 201, 80, 71),
                  ),
                  Stat(
                    name: 'DEX',
                    value: 10,
                    backgroundColor: const Color.fromARGB(255, 75, 209, 80),
                  ),
                  Stat(
                    name: 'INT',
                    value: 10,
                    backgroundColor: const Color.fromARGB(255, 70, 152, 219),
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


  void _goOnQuest() {
    Quest quest = Quest(
            name: 'Giant Centipede',
            iconPath: 'assets/images/questIcons/Icons_21.png',
            experience: 100,
            gold: 50,
            objectives: '2500 steps',
            timeLimit: Duration(hours: 1),
            level: 'easy',
            enemy: 'centipede',
          );

  if (_views.length > 1) {
    _views[1] = BattleView(quest: quest);  // Zakładamy, że widok na indeksie 1 to BattleView
  } else {
    // Jeśli lista nie ma wystarczającej ilości elementów, dodajemy nowy widok
    _views.add(BattleView(quest: quest));
  }

  setState(() {
    _currentIndex = 1;  // Ustawiamy indeks na widok BattleView
  });
}
}
