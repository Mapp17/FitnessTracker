import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../data/location_service.dart';

enum WorkoutPhase { idle, active, finished }

class WorkoutTrackingProvider extends ChangeNotifier {
  final LocationService _locationService;

  WorkoutTrackingProvider(this._locationService);

  WorkoutPhase _workoutPhase = WorkoutPhase.idle;
  Position? _startPosition;
  Position? _endPosition;
  Position? _currentPosition;
  double _distanceMeters = 0.0;
  DateTime? _startTime;
  int _elapsedSeconds = 0;
  String? _errorMessage;
  bool _isLoadingLocation = false;
  Timer? _workoutTimer;

  // Getters
  WorkoutPhase get workoutPhase => _workoutPhase;
  Position? get startPosition => _startPosition;
  Position? get endPosition => _endPosition;
  Position? get currentPosition => _currentPosition;
  double get distanceMeters => _distanceMeters;
  DateTime? get startTime => _startTime;
  int get elapsedSeconds => _elapsedSeconds;
  String? get errorMessage => _errorMessage;
  bool get isLoadingLocation => _isLoadingLocation;

  // Computed Getters
  String get formattedTime {
    final duration = Duration(seconds: _elapsedSeconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
  }

  String get formattedDistance {
    if (_distanceMeters < 1000) {
      return "${_distanceMeters.toStringAsFixed(0)} m";
    } else {
      return "${(_distanceMeters / 1000).toStringAsFixed(1)} km";
    }
  }

  String get formattedPace {
    if (_distanceMeters > 0 && _elapsedSeconds > 0) {
      final km = _distanceMeters / 1000;
      final minutes = _elapsedSeconds / 60;
      final paceDecimal = minutes / km;
      final paceMinutes = paceDecimal.floor();
      final paceSeconds = ((paceDecimal - paceMinutes) * 60).round();
      return "$paceMinutes:${paceSeconds.toString().padLeft(2, '0')} min/km";
    }
    return "--";
  }

  bool get canFinish => _workoutPhase == WorkoutPhase.active;

  Future<void> startWorkout() async {
    _isLoadingLocation = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPosition();
      _startPosition = position;
      _currentPosition = position;
      _startTime = DateTime.now();
      _elapsedSeconds = 0;
      _workoutPhase = WorkoutPhase.active;

      _workoutTimer?.cancel();
      _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsedSeconds++;
        notifyListeners();
      });
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _workoutPhase = WorkoutPhase.idle;
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  Future<void> updateLocation() async {
    if (_workoutPhase != WorkoutPhase.active) return;

    try {
      final position = await _locationService.getCurrentPosition();
      _currentPosition = position;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> finishWorkout() async {
    if (!canFinish) return;

    _isLoadingLocation = true;
    notifyListeners();

    _workoutTimer?.cancel();

    try {
      final position = await _locationService.getCurrentPosition();
      _endPosition = position;
      if (_startPosition != null && _endPosition != null) {
        _distanceMeters = _locationService.calculateDistance(
          _startPosition!.latitude,
          _startPosition!.longitude,
          _endPosition!.latitude,
          _endPosition!.longitude,
        );
      }
      _workoutPhase = WorkoutPhase.finished;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      // Still finish the workout so the user sees their time
      _workoutPhase = WorkoutPhase.finished;
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  void resetWorkout() {
    _workoutTimer?.cancel();
    _workoutPhase = WorkoutPhase.idle;
    _startPosition = null;
    _endPosition = null;
    _currentPosition = null;
    _distanceMeters = 0.0;
    _startTime = null;
    _elapsedSeconds = 0;
    _errorMessage = null;
    _isLoadingLocation = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _workoutTimer?.cancel();
    super.dispose();
  }
}
