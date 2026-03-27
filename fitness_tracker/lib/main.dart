import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/profile_repo.dart';
import 'data/routine_repository.dart';
import 'domain/profile_provider.dart';
import 'domain/routine_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // 1. Create Repositories (Data Layer)
  final profileRepo = ProfileRepository(prefs);
  final routineRepo = RoutineRepository(prefs);

  runApp(
    MultiProvider(
      providers: [
        // 2. Inject Repositories into Providers (Domain Layer)
        ChangeNotifierProvider(create: (_) => ProfileProvider(profileRepo)),
        ChangeNotifierProvider(create: (_) => RoutineProvider(routineRepo)),
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
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.orangeAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const HomeScreen(),
    );
  }
}