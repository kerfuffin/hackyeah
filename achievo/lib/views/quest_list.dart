import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

class Quest {
  final String name;
  final String iconPath;   
  final int experience;    
  final int gold;           
  final String objectives;
  final Duration timeLimit;
  final String level;

  Quest({
    required this.name,
    required this.iconPath,
    required this.experience,
    required this.gold,
    required this.objectives,
    required this.timeLimit,
    required this.level,
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
              timeLimit: quest.timeLimit,
              level: quest.level,
            ))
        .toList();
  }

  Widget questCard(int index, Quest quest) {
  return NesContainer(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikona (square icon taking full height)
          NesContainer(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(3.8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                quest.iconPath, 
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
              ),
            )
          ),
          const SizedBox(width: 16),
          // Szczegóły zadania
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quest name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Text(
                      quest.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      quest.level,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]
                ),
                const SizedBox(height: 8),
                // Cele
                Text(
                  '${quest.objectives}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${quest.experience}exp',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        Text(
                          '${quest.gold}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 2),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/coin.png'),
                              fit: BoxFit.fitHeight,
                              filterQuality: FilterQuality.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${quest.timeLimit.inMinutes}min',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ]
                ),
              ],
            ),
          ),
        ],
      ),
    );
}



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Dostosowane odstępy wewnętrzne
        child: ListView.separated(
          itemCount: quests.length, // Liczba elementów
          separatorBuilder: (context, index) => SizedBox(height: 16), // Odstęp o wysokości 16 pikseli
          itemBuilder: (context, index) {
            Quest quest = quests[index];
            return questCard(index, quest); // Zwróć kartę questu
          },
        ),
      ),
    );
  }
}
