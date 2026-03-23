import 'package:flutter/material.dart';
import 'package:fitness_tracker/app_router.dart';

class ExerciseListScreen extends StatelessWidget {
  final String categoryName;
  final Color themeColor;
  final IconData iconData;

  const ExerciseListScreen({
    super.key,
    required this.categoryName,
    required this.themeColor,
    required this.iconData,
  });

  Color _getForegroundColor(Color backgroundColor) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  List<Map<String, dynamic>> _getExercises() {
    switch (categoryName.toLowerCase()) {
      case 'cardio':
        return [
          {'name': 'Running', 'muscleGroup': 'Legs', 'sets': 3, 'reps': 0, 'weight': 0.0},
          {'name': 'Jumping Jacks', 'muscleGroup': 'Full Body', 'sets': 3, 'reps': 30, 'weight': 0.0},
          {'name': 'Burpees', 'muscleGroup': 'Full Body', 'sets': 4, 'reps': 15, 'weight': 0.0},
          {'name': 'High Knees', 'muscleGroup': 'Legs', 'sets': 3, 'reps': 45, 'weight': 0.0},
        ];
      case 'strength':
        return [
          {'name': 'Bench Press', 'muscleGroup': 'Chest', 'sets': 4, 'reps': 10, 'weight': 60.0},
          {'name': 'Squats', 'muscleGroup': 'Legs', 'sets': 4, 'reps': 12, 'weight': 80.0},
          {'name': 'Deadlifts', 'muscleGroup': 'Back', 'sets': 3, 'reps': 8, 'weight': 100.0},
          {'name': 'Overhead Press', 'muscleGroup': 'Shoulders', 'sets': 3, 'reps': 10, 'weight': 40.0},
        ];
      case 'flexibility':
        return [
          {'name': 'Forward Fold', 'muscleGroup': 'Hamstrings', 'sets': 2, 'reps': 60, 'weight': 0.0},
          {'name': 'Cat-Cow Stretch', 'muscleGroup': 'Spine', 'sets': 2, 'reps': 15, 'weight': 0.0},
          {'name': "Child's Pose", 'muscleGroup': 'Back', 'sets': 1, 'reps': 60, 'weight': 0.0},
          {'name': 'Pigeon Pose', 'muscleGroup': 'Hips', 'sets': 2, 'reps': 45, 'weight': 0.0},
        ];
      case 'hiit':
        return [
          {'name': 'Mountain Climbers', 'muscleGroup': 'Core', 'sets': 3, 'reps': 30, 'weight': 0.0},
          {'name': 'Squat Jumps', 'muscleGroup': 'Legs', 'sets': 3, 'reps': 20, 'weight': 0.0},
          {'name': 'Plank Jacks', 'muscleGroup': 'Core', 'sets': 3, 'reps': 25, 'weight': 0.0},
          {'name': 'Box Jumps', 'muscleGroup': 'Legs', 'sets': 4, 'reps': 12, 'weight': 0.0},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final foregroundColor = _getForegroundColor(themeColor);
    final exercises = _getExercises();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          '$categoryName Exercises',
          style: TextStyle(color: foregroundColor),
        ),
        backgroundColor: themeColor,
        iconTheme: IconThemeData(color: foregroundColor),
        elevation: 0,
      ),
      body: exercises.isEmpty
          ? Center(
              child: Text(
                'No exercises available for $categoryName',
                style: TextStyle(color: Colors.grey[500]),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                final exerciseName = exercise['name'] as String;
                final muscleGroup = exercise['muscleGroup'] as String;
                final sets = exercise['sets'] as int;
                final reps = exercise['reps'] as int;
                final weight = exercise['weight'] as double;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: themeColor.withOpacity(0.3), width: 1),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.pushRoute(
                          AppRoute.exerciseDetail,
                          ExerciseDetailArgs(
                            exerciseName: exerciseName,
                            muscleGroup: muscleGroup,
                            sets: sets,
                            reps: reps,
                            weight: weight,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: themeColor.withOpacity(0.2),
                              child: Icon(iconData, color: themeColor, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exerciseName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    muscleGroup,
                                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildStatChip('$sets sets', themeColor),
                                      const SizedBox(width: 8),
                                      _buildStatChip(reps > 0 ? '$reps reps' : 'Time-based', themeColor),
                                      if (weight > 0) ...[
                                        const SizedBox(width: 8),
                                        _buildStatChip('${weight.toStringAsFixed(0)} kg', themeColor),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, color: themeColor, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
