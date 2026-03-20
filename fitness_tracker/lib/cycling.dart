import 'package:flutter/material.dart';

class Cycling extends StatefulWidget {
  const Cycling({super.key});

  @override
  State<Cycling> createState() => _CyclingState();
}

class _CyclingState extends State<Cycling> {
  final List<Map<String, dynamic>> distances = [
    {"label": "5 km Ride", "color": Colors.green},
    {"label": "10 km Ride", "color": Colors.blue},
    {"label": "20 km Ride", "color": Colors.orange},
    {"label": "50 km Ride", "color": Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Cycling Activities"),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: distances.length,
        itemBuilder: (context, index) {
          final distance = distances[index];
          return Card(
            color: distance["color"].withOpacity(0.2),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.directions_bike, color: Colors.white),
              title: Text(
                distance["label"],
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              subtitle: const Text(
                "Tap to start this ride",
                style: TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                // Example navigation: push to a details screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RideDetailPage(distance: distance["label"]),
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

class RideDetailPage extends StatelessWidget {
  final String distance;
  const RideDetailPage({super.key, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(distance)),
      body: Center(
        child: Text(
          "Details for $distance ride",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}