import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_router.dart';
import '../../providers//exercise_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final foregroundColor = _getForegroundColor(themeColor);
    
    // Use ExerciseProvider to get exercises for this category
    final exercises = context.watch<ExerciseProvider>().getExercisesByCategory(categoryName);

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
                            exerciseName: exercise.name,
                            muscleGroup: exercise.muscleGroup,
                            sets: exercise.sets,
                            reps: exercise.reps,
                            weight: exercise.weight,
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
                                    exercise.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    exercise.muscleGroup,
                                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildStatChip('${exercise.sets} sets', themeColor),
                                      const SizedBox(width: 8),
                                      _buildStatChip(exercise.reps > 0 ? '${exercise.reps} reps' : 'Time-based', themeColor),
                                      if (exercise.weight > 0) ...[
                                        const SizedBox(width: 8),
                                        _buildStatChip('${exercise.weight.toStringAsFixed(0)} kg', themeColor),
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
