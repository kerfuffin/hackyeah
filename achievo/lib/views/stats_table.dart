import 'package:flutter/material.dart';

class Stat {
  final String name;
  final int value;
  final Color backgroundColor;

  Stat({
    required this.name,
    required this.value,
    required this.backgroundColor,
  });
}

class StatsTable extends StatefulWidget {
  final List<Stat> initialStats;
  final Function(List<Stat>)? onStatsChanged;

  StatsTable({
    Key? key,
    required this.initialStats,
    this.onStatsChanged,
  }) : super(key: key);

  @override
  _StatsTableState createState() => _StatsTableState();
}

class _StatsTableState extends State<StatsTable> {
  late List<Stat> stats;

  @override
  void initState() {
    super.initState();
    stats = widget.initialStats
        .map((stat) => Stat(
            name: stat.name,
            value: stat.value,
            backgroundColor: stat.backgroundColor))
        .toList();
  }

  Widget statCard(int index, Stat stat) {
    return Container(
      decoration: BoxDecoration(
        color: stat.backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0), // Reduced horizontal padding
      margin: const EdgeInsets.symmetric(horizontal: 4.0), // Reduced horizontal margin
      width: 80, // Set a narrower fixed width for the stat boxes
      height: 60, // Keep the height fixed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Align text to the bottom
        children: [
          Text(
            '${stat.name}: ${stat.value}',
            style: TextStyle(fontSize: 16.0, color: Colors.white), // Font size
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Adjusted padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...stats.asMap().entries.map((entry) {
              int index = entry.key;
              Stat stat = entry.value;
              return statCard(index, stat);
            }).toList(),
          ],
        ),
      ),
    );
  }
}
