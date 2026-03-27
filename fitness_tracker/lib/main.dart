import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/app_router.dart';
import 'package:fitness_tracker/domain/routine_provider.dart';
import 'package:fitness_tracker/domain/exercise_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoutineProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
      ],
      child: const FitnessTrackerApp(),
    ),
  );
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
        ),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Access categories from ExerciseProvider
    final categories = context.watch<ExerciseProvider>().categories;

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
                          color: Colors.orange.withAlpha(77),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Workout Categories",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.pushRouteNoArgs(AppRoute.browseExercises),
                    child: const Text("View All"),
                  ),
                ],
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
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];

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
                                categoryName: category.name,
                                themeColor: category.color,
                                iconData: category.icon,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: category.color.withAlpha(51),
                                child: Icon(
                                  category.icon,
                                  color: category.color,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                category.name,
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already at Home
              break;
            case 1:
              context.pushRouteNoArgs(AppRoute.browseExercises);
              break;
            case 2:
              context.pushRouteNoArgs(AppRoute.addExercise);
              break;
            case 3:
              context.pushRouteNoArgs(AppRoute.routineSummary);
              break;
            case 4:
              context.pushRouteNoArgs(AppRoute.bmiCalculator);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Routine'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'BMI'),
        ],
      ),
    );
  }
}
