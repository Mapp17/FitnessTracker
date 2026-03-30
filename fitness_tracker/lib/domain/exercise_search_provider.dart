import 'package:flutter/material.dart';
import 'package:fitness_tracker/data/models/api_exercise.dart';
import 'package:fitness_tracker/data/exercise_api_repository.dart';

class ExerciseSearchProvider extends ChangeNotifier {
  final ExerciseApiRepository _apiRepository;

  ExerciseSearchProvider(this._apiRepository);

  List<ApiExercise> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Last query params for retry
  String _lastMuscle = '';
  String _lastType = '';
  String _lastDifficulty = '';
  String _lastName = '';

  // Getters
  List<ApiExercise> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get lastQuery => _lastName; // For generic empty state check
  bool get hasResults => _searchResults.isNotEmpty;
  bool get hasError => _errorMessage != null;

  /// Searches for exercises with multiple filters.
  Future<void> searchExercises({
    String? muscle,
    String? type,
    String? difficulty,
    String? name,
  }) async {
    // Basic validation: at least one filter should be active if we want to avoid broad searches
    // but the API allows it. We'll follow the requirement of trimming and checking empty for name.
    final nameQuery = name?.trim().toLowerCase() ?? '';
    
    _lastMuscle = muscle ?? '';
    _lastType = type ?? '';
    _lastDifficulty = difficulty ?? '';
    _lastName = nameQuery;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _apiRepository.searchExercises(
        muscle: _lastMuscle,
        type: _lastType,
        difficulty: _lastDifficulty,
        name: _lastName,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Retries the last performed search.
  Future<void> retry() async {
    await searchExercises(
      muscle: _lastMuscle,
      type: _lastType,
      difficulty: _lastDifficulty,
      name: _lastName,
    );
  }

  /// Resets the search state to defaults.
  void clearResults() {
    _searchResults = [];
    _isLoading = false;
    _errorMessage = null;
    _lastMuscle = '';
    _lastType = '';
    _lastDifficulty = '';
    _lastName = '';
    notifyListeners();
  }
}
