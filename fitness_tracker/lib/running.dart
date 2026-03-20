import 'package:flutter/material.dart';

class Running extends StatefulWidget {
  const Running({super.key});

  @override
  State<Running> createState() => _RunningState();
}

class _RunningState extends State<Running> {
  final List<Map<String, dynamic>> runs = [
    {"label": "3 km Run", "color": Colors.green, "isFavorite": false},
    {"label": "5 km Run", "color": Colors.blue, "isFavorite": false},
    {"label": "10 km Run", "color": Colors.orange, "isFavorite": false},
    {"label": "21 km Half Marathon", "color": Colors.red, "isFavorite": false},
    {"label": "42 km Marathon", "color": Colors.purple, "isFavorite": false},
  ];

  void _toggleFavorite(int index) {
    setState(() {
      runs[index]["isFavorite"] = !runs[index]["isFavorite"];
    });
    
    final label = runs[index]["label"];
    final isFav = runs[index]["isFavorite"];
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFav ? "Added $label to favorites" : "Removed $label from favorites"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "Running Activities",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: runs.length,
        itemBuilder: (context, index) {
          final run = runs[index];
          final bool isFavorite = run["isFavorite"];

          return Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: isFavorite ? Colors.orangeAccent : Colors.transparent,
                width: 1,
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (run["color"] as Color).withOpacity(0.2),
                child: Icon(Icons.directions_run, color: run["color"]),
              ),
              title: Text(
                run["label"],
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Tap to see details",
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.redAccent : Colors.grey,
                    ),
                    onPressed: () => _toggleFavorite(index),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RunDetailPage(distance: run["label"]),
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

class RunDetailPage extends StatelessWidget {
  final String distance;
  const RunDetailPage({super.key, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(distance, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_run, size: 100, color: Colors.orangeAccent),
            const SizedBox(height: 20),
            Text(
              "Details for $distance",
              style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
