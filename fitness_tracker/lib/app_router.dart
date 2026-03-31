import 'package:fitness_tracker/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/presentation/screens/exercise_list_screen.dart';
import 'package:fitness_tracker/exercise_detail_screen.dart';
import 'package:fitness_tracker/bmi_calculator.dart';
import 'package:fitness_tracker/presentation/screens/add_exercise_screen.dart';
import 'package:fitness_tracker/presentation/screens/exercise_browse_screen.dart';
import 'package:fitness_tracker/presentation/screens/routine_summary_screen.dart';
import 'package:fitness_tracker/presentation/screens/dashboard_screen.dart';
import 'package:fitness_tracker/presentation/screens/main_navigation_screen.dart';
import 'package:fitness_tracker/presentation/screens/exercise_search_screen.dart';
import 'package:fitness_tracker/presentation/screens/outdoor_workout_screen.dart';

// TYPE-SAFE ARGUMENT CLASSES

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
  root,
  home,
  dashboard,
  exerciseList,
  exerciseDetail,
  bmiCalculator,
  addExercise,
  browseExercises,
  routineSummary,
  exerciseSearch,
  outdoorWorkout;

  MaterialPageRoute route(T args) {
    switch (this) {
      case AppRoute.root:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
          settings: const RouteSettings(name: 'root'),
        );
      case AppRoute.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: const RouteSettings(name: 'home'),
        );
      case AppRoute.dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
          settings: const RouteSettings(name: 'dashboard'),
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
      case AppRoute.exerciseSearch:
        return MaterialPageRoute(
          builder: (_) => const ExerciseSearchScreen(),
          settings: const RouteSettings(name: 'exerciseSearch'),
        );
      case AppRoute.outdoorWorkout:
        return MaterialPageRoute(
          builder: (_) => const OutdoorWorkoutScreen(),
          settings: const RouteSettings(name: 'outdoorWorkout'),
        );
    }
  }
}

// NAVIGATOR EXTENSION

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
