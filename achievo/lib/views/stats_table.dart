import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

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
    return NesContainer(
      width: 100, // Fixed width for the stat boxes
      height: 50, // Reduced height for the stat boxes
      padding: EdgeInsets.zero,
      backgroundColor: stat.backgroundColor,
      child: Center( 
        child: Text(
          '${stat.name}: ${stat.value}',
          style: TextStyle(fontSize: 20.0, color: Colors.white),
          textAlign: TextAlign.center,
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
