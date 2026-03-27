import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';

class RoutineRepository {
  static const String _key = 'daily_routine';
  final SharedPreferences _prefs;

  RoutineRepository(this._prefs);

  /// Saves the entire list of exercises as a JSON array string.
  Future<void> saveRoutine(List<Exercise> routine) async {
    final List<Map<String, dynamic>> jsonList = routine.map((e) => e.toJson()).toList();
    await _prefs.setString(_key, jsonEncode(jsonList));
  }

  /// Loads the routine from disk. Returns an empty list if no data is found or on error.
  List<Exercise> loadRoutine() {
    try {
      final String? data = _prefs.getString(_key);
      if (data == null) return [];
      
      final List<dynamic> decodedList = jsonDecode(data);
      return decodedList.map((item) => Exercise.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      // In a production app, you might log this error to a service like Sentry.
      return [];
    }
  }

  /// Removes the routine data from persistence.
  Future<void> clearRoutine() async {
    await _prefs.remove(_key);
  }
}
