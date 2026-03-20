import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WeightWorkouts(),
  ));
}

class WeightWorkouts extends StatefulWidget {
  const WeightWorkouts({super.key});

  @override
  State<WeightWorkouts> createState() => _WeightWorkoutsState();
}

class _WeightWorkoutsState extends State<WeightWorkouts> {
  final List<Map<String, dynamic>> workouts = [
    {"label": "Bench Press", "color": Colors.red},
    {"label": "Squats", "color": Colors.blue},
    {"label": "Deadlifts", "color": Colors.orange},
    {"label": "Shoulder Press", "color": Colors.green},
    {"label": "Bicep Curls", "color": Colors.purple},
    {"label": "Tricep Extensions", "color": Colors.teal},
    {"label": "Pull Ups", "color": Colors.indigo},
    {"label": "Lunges", "color": Colors.brown},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Weight Workouts"),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Card(
            color: workout["color"].withOpacity(0.2),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.fitness_center, color: Colors.white),
              title: Text(
                workout["label"],
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              subtitle: const Text(
                "Tap to view workout details",
                style: TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutDetailPage(workout: workout["label"]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class WorkoutDetailPage extends StatelessWidget {
  final String workout;
  const WorkoutDetailPage({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(workout)),
      body: Center(
        child: Text(
          "Details for $workout",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}