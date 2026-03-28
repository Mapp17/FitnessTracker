import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/exercise.dart';
import '../../domain/routine_provider.dart';

class ExerciseBrowseScreen extends StatelessWidget {
  const ExerciseBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Exercise> availableExercises = [
      const Exercise(id: '1', name: 'Bench Press', muscleGroup: 'Chest', sets: 3, reps: 10, weight: 60.0),
      const Exercise(id: '2', name: 'Dumbbell Flyes', muscleGroup: 'Chest', sets: 3, reps: 12, weight: 15.0),
      const Exercise(id: '3', name: 'Pull Ups', muscleGroup: 'Back', sets: 3, reps: 8, weight: 0.0),
      const Exercise(id: '4', name: 'Bent Over Rows', muscleGroup: 'Back', sets: 4, reps: 10, weight: 50.0),
      const Exercise(id: '5', name: 'Squats', muscleGroup: 'Legs', sets: 4, reps: 10, weight: 80.0),
      const Exercise(id: '6', name: 'Leg Press', muscleGroup: 'Legs', sets: 3, reps: 12, weight: 120.0),
      const Exercise(id: '7', name: 'Bicep Curls', muscleGroup: 'Arms', sets: 3, reps: 12, weight: 12.5),
      const Exercise(id: '8', name: 'Tricep Extensions', muscleGroup: 'Arms', sets: 3, reps: 15, weight: 10.0),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Browse Exercises"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: availableExercises.length,
        itemBuilder: (context, index) {
          final exercise = availableExercises[index];
          
          // Reactive UI using context.watch
          final routineProvider = context.watch<RoutineProvider>();
          final bool isAdded = routineProvider.isInRoutine(exercise.id);

          return Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: isAdded ? Colors.orangeAccent : Colors.transparent,
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: _getMuscleColor(exercise.muscleGroup).withOpacity(0.2),
                child: Icon(_getMuscleIcon(exercise.muscleGroup), color: _getMuscleColor(exercise.muscleGroup)),
              ),
              title: Text(
                exercise.name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.muscleGroup, style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(height: 4),
                  Text(
                    "${exercise.sets} × ${exercise.reps} @ ${exercise.weight}kg",
                    style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: isAdded 
                  ? null 
                  : () => context.read<RoutineProvider>().addExercise(exercise),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAdded ? Colors.grey : Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: isAdded 
                  ? const Icon(Icons.check, size: 20) 
                  : const Text("ADD"),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getMuscleColor(String group) {
    switch (group) {
      case 'Chest': return Colors.redAccent;
      case 'Back': return Colors.blueAccent;
      case 'Legs': return Colors.greenAccent;
      case 'Arms': return Colors.purpleAccent;
      default: return Colors.orangeAccent;
    }
  }

  IconData _getMuscleIcon(String group) {
    switch (group) {
      case 'Chest': return Icons.front_hand;
      case 'Back': return Icons.accessibility;
      case 'Legs': return Icons.directions_run;
      case 'Arms': return Icons.fitness_center;
      default: return Icons.bolt;
    }
  }
}
