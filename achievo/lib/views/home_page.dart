import 'package:achievo/views/battle_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:achievo/controllers/token_controller.dart';
import 'package:achievo/models/user_data.dart';
import 'stats_table.dart';
import 'quest_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TokenController? _tokenController;
  UserData? _userData;

  @override
  void initState() {
    super.initState();
    _tokenController = TokenController();
    _tokenController!.initialize().then((_) {
      _tokenController!.startSendingToken();

      // Listen for updates
      _tokenController!.userDataNotifier.addListener(_onDataUpdated);
    });
  }

  void _onDataUpdated() {
    setState(() {
      _userData = _tokenController!.userDataNotifier.value;
    });
  }

  @override
  void dispose() {
    _tokenController?.userDataNotifier.removeListener(_onDataUpdated);
    _tokenController?.stopSendingToken();
    super.dispose();
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
            child: BattleView(
              backgroundImagePath: 'assets/images/Background.png',
              characterImagePath: 'assets/images/character.png', // Path to your character image
              enemyImagePath: 'assets/images/enemy.png', // Path to your enemy image
              enemyHealth: 1500, // Example current health of the enemy
              maxEnemyHealth: 2000, // Example max health of the enemy
              timeLeft: 10, // Example time left for the action
              maxTime: 20, // Example max time for the action
              onAbandon: _onAbandon, // Pass the function to the BattleView
            ),
            ),
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

  void _onAbandon() {
    print('Abandon battle');
  }
}
