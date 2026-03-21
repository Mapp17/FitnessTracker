import 'package:flutter/material.dart';
import 'package:fitness_tracker/navigation.dart';
import 'package:fitness_tracker/running.dart';
import 'package:fitness_tracker/cycling.dart';
import 'package:fitness_tracker/weights.dart';
import 'package:fitness_tracker/add_exercise_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.orange,
    ),
      home: const Home()
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPage = 0;
  
  final List<Map<String, dynamic>> workoutCategories = [
    {
      "name": "Running", 
      "icon": Icons.directions_run, 
      "color": Colors.orangeAccent,
      "page": const Running()
    },
    {
      "name": "Cycling", 
      "icon": Icons.directions_bike, 
      "color": Colors.blueAccent,
      "page": const Cycling()
    },
    {
      "name": "Weights", 
      "icon": Icons.fitness_center, 
      "color": Colors.redAccent,
      "page": const WeightWorkouts()
    },
    {
      "name": "Hiking", 
      "icon": Icons.terrain, 
      "color": Colors.brown,
      "page": null // Placeholder for future implementation
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "Fitness Tracker",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.grey[400],
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Hello, Mapps!",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontStyle: FontStyle.italic,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 20.0),
              
              // Featured Banner
              Stack(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [Colors.orangeAccent, Colors.deepOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Featured Workout",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Full Body HIIT\n30 Minutes • Advanced",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Start",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              
              Text(
                "Workout Categories",
                style: TextStyle(
                  color: Colors.grey[300],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16.0),
              

              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2;
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 4;
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 3;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: workoutCategories.length,
                    itemBuilder: (context, index) {
                      final category = workoutCategories[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[800]!, width: 1),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (category['page'] != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => category['page']),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${category['name']} coming soon!")),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: (category['color'] as Color).withOpacity(0.2),
                                child: Icon(
                                  category['icon'],
                                  color: category['color'],
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                category['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.orangeAccent,
      child: const Icon(Icons.add),
      onPressed: () async {

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddExerciseScreen(),
          ),
        );

        if (result != null) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Exercise '${result['name']}' added!"),
            ),
          );
        }
      },
    ),
      bottomNavigationBar: const Bottom_Navigation(),
    );
  }
}
