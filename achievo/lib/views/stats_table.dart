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
      width: 80, // Fixed width for the stat boxes
      height: 50, // Reduced height for the stat boxes
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.black, width: 1.0), // Very thin black outer border
        borderRadius: BorderRadius.circular(8.0), // Uniform border radius
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.brown, width: 3.0), // Thick brown inner border
          borderRadius:
              BorderRadius.circular(7.0), // Same radius as outer border
        ),
        child: Container(
          decoration: BoxDecoration(
            color: stat.backgroundColor, // Background color for the stat
            border: Border.all(
                color: Colors.black,
                width: 1.0), // Very thin black inner border
            borderRadius:
                BorderRadius.circular(4.0), // Same radius as other borders
          ),
          alignment: Alignment.center, // Center the text
          child: Text(
            '${stat.name}: ${stat.value}',
            style: TextStyle(fontSize: 16.0, color: Colors.white), // Font size
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(32.0), // Adjusted padding
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
