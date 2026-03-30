import 'package:flutter/material.dart';
import 'package:fitness_tracker/data/models/api_exercise.dart';
import 'package:fitness_tracker/data/exercise_api_repository.dart';

class ExerciseSearchProvider extends ChangeNotifier {
  final ExerciseApiRepository _apiRepository;

  ExerciseSearchProvider(this._apiRepository);

  List<ApiExercise> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _lastQuery = '';

  // Getters
  List<ApiExercise> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get lastQuery => _lastQuery;
  bool get hasResults => _searchResults.isNotEmpty;
  bool get hasError => _errorMessage != null;

  /// Searches for exercises by muscle group.
  Future<void> searchExercises(String muscle) async {
    final query = muscle.trim().toLowerCase();
    
    // Return early if query is empty
    if (query.isEmpty) return;

    _lastQuery = query;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _apiRepository.searchExercises(query);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Retries the last search.
  Future<void> retry() async {
    if (_lastQuery.isNotEmpty) {
      await searchExercises(_lastQuery);
    }
  }

  /// Resets the search to defaults.
  void clearResults() {
    _searchResults = [];
    _isLoading = false;
    _errorMessage = null;
    _lastQuery = '';
    notifyListeners();
  }
}
