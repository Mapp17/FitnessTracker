import 'dart:convert';

class UserProfile {
  final String name;
  final int age;
  final double weightGoal;
  final String weightUnit; // 'kg' or 'lbs'
  final int restTimerSeconds; // 15-300
  final bool notificationsEnabled;

  const UserProfile({
    required this.name,
    required this.age,
    required this.weightGoal,
    required this.weightUnit,
    required this.restTimerSeconds,
    required this.notificationsEnabled,
  });

  factory UserProfile.defaults() {
    return const UserProfile(
      name: 'Mapps',
      age: 25,
      weightGoal: 75.0,
      weightUnit: 'kg',
      restTimerSeconds: 60,
      notificationsEnabled: true,
    );
  }

  UserProfile copyWith({
    String? name,
    int? age,
    double? weightGoal,
    String? weightUnit,
    int? restTimerSeconds,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      weightGoal: weightGoal ?? this.weightGoal,
      weightUnit: weightUnit ?? this.weightUnit,
      restTimerSeconds: restTimerSeconds ?? this.restTimerSeconds,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'weightGoal': weightGoal,
    'weightUnit': weightUnit,
    'restTimerSeconds': restTimerSeconds,
    'notificationsEnabled': notificationsEnabled,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {

    int timer = (json['restTimerSeconds'] as int? ?? 60).clamp(15, 300);
    String unit = (json['weightUnit'] == 'lbs') ? 'lbs' : 'kg';

    return UserProfile(
      name: json['name'] as String? ?? 'Athlete',
      age: json['age'] as int? ?? 25,
      weightGoal: (json['weightGoal'] as num? ?? 75.0).toDouble(),
      weightUnit: unit,
      restTimerSeconds: timer,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    );
  }
}