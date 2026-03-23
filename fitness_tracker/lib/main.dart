import 'package:flutter/material.dart';
import 'package:fitness_tracker/app_router.dart';

void main() {
  runApp(const FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.orangeAccent,
          secondary: Colors.orangeAccent,
          surface: Colors.grey[850]!,
          background: Colors.grey[900]!,
        ),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  final List<Map<String, dynamic>> workoutCategories = const [
    {
      "name": "Cardio",
      "icon": Icons.favorite,
      "color": Colors.redAccent,
    },
    {
      "name": "Strength",
      "icon": Icons.fitness_center,
      "color": Colors.blueAccent,
    },
    {
      "name": "Flexibility",
      "icon": Icons.accessibility_new,
      "color": Colors.greenAccent,
    },
    {
      "name": "HIIT",
      "icon": Icons.bolt,
      "color": Colors.orangeAccent,
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
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.fitness_center, color: Colors.orangeAccent),
            onPressed: () {
              context.pushRouteNoArgs(AppRoute.addExercise);
            },
            tooltip: 'Add Exercise',
          ),
          IconButton(
            icon: const Icon(Icons.calculate, color: Colors.orangeAccent),
            onPressed: () {
              context.pushRouteNoArgs(AppRoute.bmiCalculator);
            },
            tooltip: 'BMI Calculator',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Athlete!",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontStyle: FontStyle.italic,
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
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
                      onPressed: () {
                        context.pushRoute(
                          AppRoute.exerciseList,
                          ExerciseListArgs(
                            categoryName: "HIIT",
                            themeColor: Colors.orangeAccent,
                            iconData: Icons.bolt,
                          ),
                        );
                      },
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
                      final categoryName = category["name"] as String;
                      final icon = category["icon"] as IconData;
                      final color = category["color"] as Color;

                      return Ink(
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[800]!, width: 1),
                        ),
                        child: InkWell(
                          onTap: () {
                            context.pushRoute(
                              AppRoute.exerciseList,
                              ExerciseListArgs(
                                categoryName: categoryName,
                                themeColor: color,
                                iconData: icon,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: color.withOpacity(0.2),
                                child: Icon(
                                  icon,
                                  color: color,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                categoryName,
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
    );
  }
}
