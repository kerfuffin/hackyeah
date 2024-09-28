import 'package:flutter/material.dart';

class Quest {
  final String name;
  final String iconPath;   
  final int experience;    
  final int gold;           
  final String objectives; 
  final String reward;
  final Duration timeLimit;

  Quest({
    required this.name,
    required this.iconPath,
    required this.experience,
    required this.gold,
    required this.objectives,
    required this.reward,
    required this.timeLimit,
  });
}

class QuestList extends StatefulWidget {
  final List<Quest> initialQuests;
  final Function(List<Quest>)? onQuestsChanged;

  QuestList({
    Key? key,
    required this.initialQuests,
    this.onQuestsChanged,
  }) : super(key: key);

  @override
  _QuestListState createState() => _QuestListState();
}

class _QuestListState extends State<QuestList> {
  late List<Quest> quests;

  @override
  void initState() {
    super.initState();
    quests = widget.initialQuests
        .map((quest) => Quest(
              name: quest.name,
              iconPath: quest.iconPath,
              experience: quest.experience,
              gold: quest.gold,
              objectives: quest.objectives,
              reward: quest.reward,
              timeLimit: quest.timeLimit,
            ))
        .toList();
  }

  Widget questCard(int index, Quest quest) {
  return Card(
    elevation: 4,
    margin: const EdgeInsets.all(10),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikona (square icon taking full height)
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: AssetImage(quest.iconPath),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Szczegóły zadania
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quest name
                Text(
                  quest.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Cele
                Text(
                  '${quest.objectives}',
                  style: const TextStyle(fontSize: 10),
                ),
                const SizedBox(height: 4),
                // Nagroda z ikoną pieniążka
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/coin.png'),
                          fit: BoxFit.fitHeight,
                          filterQuality: FilterQuality.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4), // Space between image and text
                    Text(
                      '${quest.gold}', // Display the gold amount
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                // Doświadczenie
                Text(
                  '${quest.experience} exp',
                  style: const TextStyle(fontSize: 10),
                ),
                // Limit czasowy
                Text(
                  'Limit czasowy: ${quest.timeLimit.inMinutes} minut',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Adjusted padding
        child: ListView(
          children: [
            ...quests.asMap().entries.map((entry) {
              int index = entry.key;
              Quest quest = entry.value;
              return questCard(index, quest);
            }).toList(),
          ],
        ),
      ),
    );
  }
}
