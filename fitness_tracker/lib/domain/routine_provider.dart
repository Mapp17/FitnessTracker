import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../data/routine_repository.dart';

class RoutineProvider extends ChangeNotifier {
  final RoutineRepository _repository;
  List<Exercise> _routine = [];

  RoutineProvider(this._repository) {
    _routine = _repository.loadRoutine();
  }

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
      _saveAndNotify();
    }
  }

  void removeExercise(String id) {
    _routine.removeWhere((item) => item.id == id);
    _saveAndNotify();
  }

  void clearRoutine() {
    _routine.clear();
    _saveAndNotify();
  }

  void _saveAndNotify() {
    notifyListeners();
    _repository.saveRoutine(_routine);
  }
}
