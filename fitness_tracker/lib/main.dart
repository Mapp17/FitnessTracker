import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/auth_service.dart';
import 'data/profile_repo.dart';
import 'data/routine_repository.dart';
import 'data/exercise_api_repository.dart';
import 'data/location_service.dart';
import 'data/notification_service.dart';
import 'domain/auth_provider.dart';
import 'domain/profile_provider.dart';
import 'domain/routine_provider.dart';
import 'domain/exercise_provider.dart';
import 'domain/exercise_search_provider.dart';
import 'domain/workout_tracking_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  final notificationService = NotificationService();
  await notificationService.init();

  final prefs = await SharedPreferences.getInstance();

  final authService = AuthService();
  final profileRepo = ProfileRepository(prefs);
  final routineRepo = RoutineRepository(prefs);
  final apiRepository = ExerciseApiRepository();
  final locationService = LocationService();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: notificationService),
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(create: (_) => ProfileProvider(profileRepo)),
        ChangeNotifierProvider(create: (_) => RoutineProvider(routineRepo)),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseSearchProvider(apiRepository)),
        ChangeNotifierProvider(create: (_) => WorkoutTrackingProvider(locationService)),
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
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          // If the app is still checking for a persisted session
          if (auth.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.orangeAccent),
              ),
            );
          }

          return auth.userId != null
              ? const MainNavigationScreen()
              : const LoginScreen();
        },
      ),
    );
  }
}
