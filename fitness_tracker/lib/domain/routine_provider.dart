import 'package:flutter/material.dart';
import '../models/exercise.dart';

class RoutineProvider extends ChangeNotifier {
  final List<Exercise> _routine = [];

  List<Exercise> get routine => List.unmodifiable(_routine);

  int get exerciseCount => _routine.length;

  int get totalSets => _routine.fold(0, (sum, item) => sum + item.sets);

  double get totalVolume => _routine.fold(0.0, (sum, item) => sum + item.volume);

  bool isInRoutine(String id) => _routine.any((item) => item.id == id);

  Map<String, int> get muscleGroupBreakdown {
    final Map<String, int> breakdown = {};
    for (var exercise in _routine) {
      breakdown[exercise.muscleGroup] = (breakdown[exercise.muscleGroup] ?? 0) + 1;
    }
    return breakdown;
  }

  void addExercise(Exercise exercise) {
    if (!isInRoutine(exercise.id)) {
      _routine.add(exercise);
      notifyListeners();
    }
  }

  void removeExercise(String id) {
    _routine.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearRoutine() {
    _routine.clear();
    notifyListeners();
  }
}
