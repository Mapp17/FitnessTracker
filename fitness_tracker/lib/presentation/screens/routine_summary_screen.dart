import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/routine_provider.dart';
import '../../app_router.dart';

class RoutineSummaryScreen extends StatelessWidget {
  const RoutineSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routineProvider = context.watch<RoutineProvider>();
    final routine = routineProvider.routine;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("My Daily Routine"),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          if (routine.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
              onPressed: () => _showClearConfirmation(context),
              tooltip: 'Clear Routine',
            ),
        ],
      ),
      body: routine.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                _buildStatsPanel(routineProvider),
                _buildMuscleBreakdown(routineProvider),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Exercises",
                      style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: routine.length,
                    itemBuilder: (context, index) {
                      final exercise = routine[index];
                      return Dismissible(
                        key: Key(exercise.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          context.read<RoutineProvider>().removeExercise(exercise.id);
                        },
                        child: Card(
                          color: Colors.grey[850],
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              exercise.name,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${exercise.muscleGroup} • ${exercise.sets}×${exercise.reps} @ ${exercise.weight}kg",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("Volume", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                Text(
                                  "${exercise.volume.toStringAsFixed(0)}kg",
                                  style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatsPanel(RoutineProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.grey[850]!, Colors.grey[800]!],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("Exercises", provider.exerciseCount.toString()),
          _buildStatItem("Sets", provider.totalSets.toString()),
          _buildStatItem("Volume", "${provider.totalVolume.toStringAsFixed(0)}kg"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMuscleBreakdown(RoutineProvider provider) {
    final breakdown = provider.muscleGroupBreakdown;
    if (breakdown.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Muscle Breakdown", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          ...breakdown.entries.map((entry) {
            final double progress = entry.value / provider.exerciseCount;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  SizedBox(width: 60, child: Text(entry.key, style: const TextStyle(color: Colors.white, fontSize: 12))),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[800],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(entry.value.toString(), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 20),
          const Text(
            "Your routine is empty",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => context.pushRouteNoArgs(AppRoute.browseExercises),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text("Browse Exercises"),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: const Text("Clear Routine?", style: TextStyle(color: Colors.white)),
        content: const Text("This will remove all exercises from your daily routine.", style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              context.read<RoutineProvider>().clearRoutine();
              Navigator.pop(context);
            },
            child: const Text("CLEAR", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
