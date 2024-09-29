// models/user_data.dart
class UserData {
  final int steps;
  final int weight;
  final int calories;
  final int sleep;
  final int xp;
  final int gold;

  UserData({
    required this.steps,
    required this.weight,
    required this.calories,
    required this.sleep,
    required this.xp,
    required this.gold,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      steps: json['steps'] ?? 0,
      weight: json['weight'] ?? 0,
      calories: json['calories'] ?? 0,
      sleep: json['sleep'] ?? 0,
      xp: json['xp'] ?? 0,
      gold: json['gold'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'weight': weight,
      'calories': calories,
      'sleep': sleep,
      'xp': xp,
      'gold': gold,
    };
  }
}
