import 'package:flutter/material.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final String exerciseName;
  final String muscleGroup;
  final int sets;
  final int reps;
  final double weight;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.weight,
  });

  double get totalVolume => sets * reps * weight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          exerciseName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Hero Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.fitness_center,
                size: 80,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 24),

            // Exercise Name
            Text(
              exerciseName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Muscle Group Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                muscleGroup,
                style: const TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Stats Card
            Card(
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Sets', '$sets', Icons.repeat),
                        _buildStatItem('Reps', reps > 0 ? '$reps' : 'Time', Icons.format_list_numbered),
                        _buildStatItem('Weight', weight > 0 ? '${weight.toStringAsFixed(0)} kg' : 'Bodyweight', Icons.fitness_center),
                      ],
                    ),
                    const Divider(color: Colors.grey, height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total Volume: ',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${totalVolume.toStringAsFixed(0)} kg',
                          style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Instructions Card
            Card(
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💪 Form Tips',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getFormTip(),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.orangeAccent, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _getFormTip() {
    switch (exerciseName.toLowerCase()) {
      case 'bench press':
        return '• Keep your feet flat on the ground\n• Maintain a slight arch in your back\n• Lower the bar to your mid-chest\n• Drive through your heels and chest';
      case 'squats':
        return '• Keep your chest up and back straight\n• Lower until thighs are parallel to ground\n• Push through your heels\n• Keep knees aligned with toes';
      case 'deadlifts':
        return '• Keep your back straight throughout\n• Engage your lats before pulling\n• Drive through your heels\n• Keep the bar close to your body';
      case 'running':
        return '• Maintain an upright posture\n• Land mid-foot, not on your heels\n• Keep your arms at 90-degree angles\n• Breathe rhythmically (2 steps inhale, 2 steps exhale)';
      default:
        return '• Maintain proper form throughout\n• Breathe consistently during the movement\n• Focus on mind-muscle connection\n• Rest adequately between sets';
    }
  }
}