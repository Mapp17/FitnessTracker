import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/workout_tracking_provider.dart';
import '../../data/notification_service.dart';

class OutdoorWorkoutScreen extends StatelessWidget {
  const OutdoorWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "GPS TRACKER",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<WorkoutTrackingProvider>(
        builder: (context, provider, child) {
          switch (provider.workoutPhase) {
            case WorkoutPhase.idle:
              return _buildIdlePhase(context, provider);
            case WorkoutPhase.active:
              return _buildActivePhase(context, provider);
            case WorkoutPhase.finished:
              return _buildFinishedPhase(context, provider);
          }
        },
      ),
    );
  }

  Widget _buildIdlePhase(BuildContext context, WorkoutTrackingProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, size: 100, color: Colors.orangeAccent),
          const SizedBox(height: 24),
          const Text(
            "Track your outdoor run with GPS",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          if (provider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent, fontSize: 14),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: provider.isLoadingLocation ? null : () => provider.startWorkout(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: provider.isLoadingLocation
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("START RUN", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivePhase(BuildContext context, WorkoutTrackingProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "ELAPSED TIME",
            style: TextStyle(color: Colors.grey, letterSpacing: 1.5, fontWeight: FontWeight.bold),
          ),
          Text(
            provider.formattedTime,
            style: const TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.my_location, size: 16, color: Colors.orangeAccent),
                const SizedBox(width: 8),
                Text(
                  "Lat: ${provider.currentPosition?.latitude.toStringAsFixed(4) ?? '--'} | Lon: ${provider.currentPosition?.longitude.toStringAsFixed(4) ?? '--'}",
                  style: const TextStyle(color: Colors.white70, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          OutlinedButton.icon(
            onPressed: () => provider.updateLocation(),
            icon: const Icon(Icons.refresh),
            label: const Text("UPDATE LOCATION"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orangeAccent,
              side: const BorderSide(color: Colors.orangeAccent),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: provider.isLoadingLocation ? null : () async {
                final duration = provider.elapsedDuration;
                final distanceKm = provider.totalDistance / 1000;
                final pace = provider.formattedPace;
                
                await provider.finishWorkout();
                
                if (context.mounted) {
                  context.read<NotificationService>().showWorkoutCompleteAlert(
                    workoutName: "Outdoor Run",
                    distanceKm: distanceKm,
                    duration: duration,
                    pace: pace,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: provider.isLoadingLocation
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("FINISH RUN", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedPhase(BuildContext context, WorkoutTrackingProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Icon(Icons.stars, size: 80, color: Colors.orangeAccent),
          const SizedBox(height: 16),
          const Text(
            "WORKOUT COMPLETE!",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Card(
            color: Colors.grey[850],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildSummaryRow("Total Time", provider.formattedTime, Icons.timer),
                  const Divider(color: Colors.grey, height: 32),
                  _buildSummaryRow("Total Distance", provider.formattedDistance, Icons.directions_run),
                  const Divider(color: Colors.grey, height: 32),
                  _buildSummaryRow("Average Pace", provider.formattedPace, Icons.speed),
                  const Divider(color: Colors.grey, height: 32),
                  _buildLocationRow("Start Location", provider.startPosition),
                  const SizedBox(height: 16),
                  _buildLocationRow("End Location", provider.endPosition),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () => provider.resetWorkout(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("NEW WORKOUT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.orangeAccent, size: 24),
        const SizedBox(width: 16),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        const Spacer(),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLocationRow(String label, dynamic position) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          position != null
              ? "Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}"
              : "Location unavailable",
          style: const TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'monospace'),
        ),
      ],
    );
  }
}
