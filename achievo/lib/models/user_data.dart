// models/user_data.dart
class UserData {
  final int steps;
  final int weight;
  final int calories;
  final int sleep;

  UserData({
    required this.steps,
    required this.weight,
    required this.calories,
    required this.sleep,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      steps: json['steps'] ?? 0,
      weight: json['weight'] ?? 0,
      calories: json['calories'] ?? 0,
      sleep: json['sleep'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'weight': weight,
      'calories': calories,
      'sleep': sleep,
    };
  }
}
