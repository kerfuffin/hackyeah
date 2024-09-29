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
  final String enemy;

  Quest({
    required this.name,
    required this.iconPath,
    required this.experience,
    required this.gold,
    required this.objectives,
    required this.timeLimit,
    required this.level,
    required this.enemy });
}

class QuestList extends StatefulWidget {
  final List<Quest> initialQuests;
  final Function(List<Quest>)? onQuestsChanged;
  final Function()? onQuestCompleted;

  QuestList({
    Key? key,
    required this.initialQuests,
    this.onQuestsChanged,
    this.onQuestCompleted
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
              enemy: quest.enemy
            ))
        .toList();
  }

  Widget questCard(int index, Quest quest) {
  return GestureDetector(
    onTap: () {
      _showQuestDetails(context, quest); // Show quest details pop-up
    },
    child: NesContainer(
      backgroundColor: const Color.fromRGBO(254, 225, 184, 1.0),
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        clipBehavior: Clip.none, // Allows content to overflow the card boundaries
        children: [
          // Main card layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quest icon (square icon taking full height)
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
                ),
              ),
              const SizedBox(width: 16),
              // Quest details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quest name and level
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Objectives
                    Text(
                      quest.objectives,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    // Rewards and time limit
                    Row(
                      children: [
                        Text(
                          '${quest.experience} exp',
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
                          '${quest.timeLimit.inMinutes} min',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Single nail image in the center of the top
          Positioned(
            top: -20,  // Adjusts vertical positioning to be above the card
            left: 0,
            right: -20,  // Center the nail by setting both `left` and `right` to 0
            child: Align(
              alignment: Alignment.topCenter,  // Ensures the nail is centered
              child: SizedBox(
                width: 30,  // Nail size (you can adjust this as needed)
                height: 30,
                child: Image.asset(
                  'assets/images/nail.png',  // Replace with your nail image path
                  fit: BoxFit.contain,  // Ensures the nail scales properly within the size box
                  filterQuality: FilterQuality.none,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }


  // Funkcja do wyświetlania szczegółów questu
  void _showQuestDetails(BuildContext context, Quest quest) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Center( 
          child: NesContainer(
            padding: EdgeInsets.zero,
            backgroundColor: Color.fromRGBO(254, 225, 184, 1.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      quest.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Objective: ${quest.objectives}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Rewards:'),
                      const SizedBox(width: 16),
                      Text('${quest.experience} exp'),
                      const SizedBox(width: 16),
                      Text('${quest.gold} gold'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Time Limit: ${quest.timeLimit.inMinutes} min'),
                  const SizedBox(height: 8),
                  Text('Level: ${quest.level}'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NesButton(
                        type: NesButtonType.success,
                        onPressed: () {
                          if (widget.onQuestCompleted != null) {
                            widget.onQuestCompleted!();
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text('Confirm'),
                      ),
                      const SizedBox(width: 16),
                      NesButton(
                        type: NesButtonType.error,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      );
    },
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
