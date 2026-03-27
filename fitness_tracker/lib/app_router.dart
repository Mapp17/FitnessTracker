import 'package:flutter/material.dart';
import 'package:fitness_tracker/exercise_list_screen.dart';
import 'package:fitness_tracker/exercise_detail_screen.dart';
import 'package:fitness_tracker/bmi_calculator.dart';
import 'package:fitness_tracker/presentation/screens/add_exercise_screen.dart';
import 'package:fitness_tracker/presentation/screens/exercise_browse_screen.dart';
import 'package:fitness_tracker/presentation/screens/routine_summary_screen.dart';
import 'package:fitness_tracker/main.dart';

// ============================================================
// TYPE-SAFE ARGUMENT CLASSES
// ============================================================

class ExerciseListArgs {
  final String categoryName;
  final Color themeColor;
  final IconData iconData;

  const ExerciseListArgs({
    required this.categoryName,
    required this.themeColor,
    required this.iconData,
  });
}

class ExerciseDetailArgs {
  final String exerciseName;
  final String muscleGroup;
  final int sets;
  final int reps;
  final double weight;

  const ExerciseDetailArgs({
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.weight,
  });
}

// ============================================================
// CENTRALIZED TYPE-SAFE ROUTER ENUM
// ============================================================

enum AppRoute<T> {
  home,
  exerciseList,
  exerciseDetail,
  bmiCalculator,
  addExercise,
  browseExercises,
  routineSummary;

  MaterialPageRoute route(T args) {
    switch (this) {
      case AppRoute.home:
        return MaterialPageRoute(
          builder: (_) => const Home(),
          settings: const RouteSettings(name: 'home'),
        );
      case AppRoute.exerciseList:
        final typedArgs = args as ExerciseListArgs;
        return MaterialPageRoute(
          builder: (_) => ExerciseListScreen(
            categoryName: typedArgs.categoryName,
            themeColor: typedArgs.themeColor,
            iconData: typedArgs.iconData,
          ),
          settings: const RouteSettings(name: 'exerciseList'),
        );
      case AppRoute.exerciseDetail:
        final typedArgs = args as ExerciseDetailArgs;
        return MaterialPageRoute(
          builder: (_) => ExerciseDetailScreen(
            exerciseName: typedArgs.exerciseName,
            muscleGroup: typedArgs.muscleGroup,
            sets: typedArgs.sets,
            reps: typedArgs.reps,
            weight: typedArgs.weight,
          ),
          settings: const RouteSettings(name: 'exerciseDetail'),
        );
      case AppRoute.bmiCalculator:
        return MaterialPageRoute(
          builder: (_) => const BMICalculator(),
          settings: const RouteSettings(name: 'bmiCalculator'),
        );
      case AppRoute.addExercise:
        return MaterialPageRoute(
          builder: (_) => const AddExerciseScreen(),
          settings: const RouteSettings(name: 'addExercise'),
        );
      case AppRoute.browseExercises:
        return MaterialPageRoute(
          builder: (_) => const ExerciseBrowseScreen(),
          settings: const RouteSettings(name: 'browseExercises'),
        );
      case AppRoute.routineSummary:
        return MaterialPageRoute(
          builder: (_) => const RoutineSummaryScreen(),
          settings: const RouteSettings(name: 'routineSummary'),
        );
    }
  }
}

// ============================================================
// NAVIGATOR EXTENSION
// ============================================================

extension NavigatorRouterExtension on BuildContext {
  void pushRoute<T>(AppRoute<T> route, T args) {
    Navigator.of(this).push(route.route(args));
  }

  void pushReplacementRoute<T>(AppRoute<T> route, T args) {
    Navigator.of(this).pushReplacement(route.route(args));
  }

  void pushRouteNoArgs(AppRoute<void> route) {
    Navigator.of(this).push(route.route(null));
  }
}
