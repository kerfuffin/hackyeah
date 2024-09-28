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
                child: Container(
                  color: const Color.fromARGB(255, 116, 46, 0),
                  child: QuestList(
          initialQuests: [
            Quest(
              name: 'Zadanie 1',
              iconPath: 'assets/images/Icons_20.png', // Ścieżka do ikony
              experience: 100,
              gold: 50,
              objectives: '2000 steps',
              timeLimit: Duration(hours: 1),
              level: 'easy'
            ),
            Quest(
              name: 'Zadanie 2',
              iconPath: 'assets/images/Icons_20.png', // Ścieżka do ikony
              experience: 200,
              gold: 100,
              objectives: '5 km',
              timeLimit: Duration(hours: 2),
              level: 'hard'
            ),]),
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
