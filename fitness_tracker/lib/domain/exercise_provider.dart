import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout_category.dart';

class ExerciseProvider extends ChangeNotifier {
  // Centralized Category List
  final List<WorkoutCategory> _categories = const [
    WorkoutCategory(
      name: "Cardio",
      icon: Icons.favorite,
      color: Colors.redAccent,
    ),
    WorkoutCategory(
      name: "Strength",
      icon: Icons.fitness_center,
      color: Colors.blueAccent,
    ),
    WorkoutCategory(
      name: "Flexibility",
      icon: Icons.accessibility_new,
      color: Colors.greenAccent,
    ),
    WorkoutCategory(
      name: "HIIT",
      icon: Icons.bolt,
      color: Colors.orangeAccent,
    ),
  ];

  // Centralized Exercise Catalog
  final List<Exercise> _catalog = [
    const Exercise(id: '1', name: 'Running', muscleGroup: 'Cardio', sets: 3, reps: 0, weight: 0.0),
    const Exercise(id: '2', name: 'Jumping Jacks', muscleGroup: 'Cardio', sets: 3, reps: 30, weight: 0.0),
    const Exercise(id: '3', name: 'Burpees', muscleGroup: 'Cardio', sets: 4, reps: 15, weight: 0.0),
    const Exercise(id: '4', name: 'High Knees', muscleGroup: 'Cardio', sets: 3, reps: 45, weight: 0.0),
    
    const Exercise(id: '5', name: 'Bench Press', muscleGroup: 'Strength', sets: 4, reps: 10, weight: 60.0),
    const Exercise(id: '6', name: 'Squats', muscleGroup: 'Strength', sets: 4, reps: 12, weight: 80.0),
    const Exercise(id: '7', name: 'Deadlifts', muscleGroup: 'Strength', sets: 3, reps: 8, weight: 100.0),
    const Exercise(id: '8', name: 'Overhead Press', muscleGroup: 'Strength', sets: 3, reps: 10, weight: 40.0),

    const Exercise(id: '9', name: 'Forward Fold', muscleGroup: 'Flexibility', sets: 2, reps: 60, weight: 0.0),
    const Exercise(id: '10', name: 'Cat-Cow Stretch', muscleGroup: 'Flexibility', sets: 2, reps: 15, weight: 0.0),
    const Exercise(id: '11', name: "Child's Pose", muscleGroup: 'Flexibility', sets: 1, reps: 60, weight: 0.0),
    const Exercise(id: '12', name: 'Pigeon Pose', muscleGroup: 'Flexibility', sets: 2, reps: 45, weight: 0.0),

    const Exercise(id: '13', name: 'Mountain Climbers', muscleGroup: 'HIIT', sets: 3, reps: 30, weight: 0.0),
    const Exercise(id: '14', name: 'Squat Jumps', muscleGroup: 'HIIT', sets: 3, reps: 20, weight: 0.0),
    const Exercise(id: '15', name: 'Plank Jacks', muscleGroup: 'HIIT', sets: 3, reps: 25, weight: 0.0),
    const Exercise(id: '16', name: 'Box Jumps', muscleGroup: 'HIIT', sets: 4, reps: 12, weight: 0.0),
  ];

  List<WorkoutCategory> get categories => _categories;
  List<Exercise> get catalog => List.unmodifiable(_catalog);

  List<Exercise> getExercisesByCategory(String categoryName) {
    return _catalog.where((e) => e.muscleGroup.toLowerCase() == categoryName.toLowerCase()).toList();
  }

  void addCustomExercise(Exercise exercise) {
    _catalog.add(exercise);
    notifyListeners();
  }
}
