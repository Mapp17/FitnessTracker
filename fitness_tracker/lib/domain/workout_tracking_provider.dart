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

  DateTime? _startTime;
  int _elapsedSeconds = 0;

  double _distanceMeters = 0.0;

  String? _errorMessage;
  bool _isLoadingLocation = false;

  Timer? _workoutTimer;
  Timer? _routeTimer;

  List<Position> _routePoints = [];

  // GETTERS

  WorkoutPhase get workoutPhase => _workoutPhase;
  Position? get startPosition => _startPosition;
  Position? get endPosition => _endPosition;
  Position? get currentPosition => _currentPosition;

  double get distanceMeters => _distanceMeters;
  double get totalDistance => _distanceMeters;
  DateTime? get startTime => _startTime;
  int get elapsedSeconds => _elapsedSeconds;
  Duration get elapsedDuration => Duration(seconds: _elapsedSeconds);

  String? get errorMessage => _errorMessage;
  bool get isLoadingLocation => _isLoadingLocation;

  List<Position> get routePoints => _routePoints;
  int get gpsPointsCount => _routePoints.length;

  bool get canFinish => _workoutPhase == WorkoutPhase.active;

  // FORMATTED VALUES

  String get formattedTime {
    final duration = Duration(seconds: _elapsedSeconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return duration.inHours > 0
        ? "$hours:$minutes:$seconds"
        : "$minutes:$seconds";
  }

  String get formattedDistance {
    if (_distanceMeters < 1000) {
      return "${_distanceMeters.toStringAsFixed(0)} m";
    } else {
      return "${(_distanceMeters / 1000).toStringAsFixed(2)} km";
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

  // WORKOUT CONTROL

  Future<void> startWorkout() async {
    _isLoadingLocation = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPosition();
      _startPosition = position;
      _currentPosition = position;
      _routePoints = [position];
      _startTime = DateTime.now();
      _elapsedSeconds = 0;
      _workoutPhase = WorkoutPhase.active;

      _startElapsedTimer();
      _startRoutePolling();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _workoutPhase = WorkoutPhase.idle;
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  void _startElapsedTimer() {
    _workoutTimer?.cancel();
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      notifyListeners();
    });
  }

  void _startRoutePolling() {
    _routeTimer?.cancel();
    _routeTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (_workoutPhase != WorkoutPhase.active) return;

      try {
        final position = await _locationService.getCurrentPosition();
        if (_routePoints.isNotEmpty) {
          final last = _routePoints.last;
          final distance = _locationService.calculateDistance(
            last.latitude,
            last.longitude,
            position.latitude,
            position.longitude,
          );
          if (distance < 2) return;
        }
        _routePoints.add(position);
        _currentPosition = position;
        notifyListeners();
      } catch (e) {
        if (kDebugMode) {
          print("GPS skipped: $e");
        }
      }
    });
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
    _routeTimer?.cancel();

    try {
      final position = await _locationService.getCurrentPosition();
      _endPosition = position;
      _routePoints.add(position);
      _distanceMeters = calculateRouteDistance();
      _workoutPhase = WorkoutPhase.finished;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _distanceMeters = calculateRouteDistance();
      _workoutPhase = WorkoutPhase.finished;
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  void resetWorkout() {
    _workoutTimer?.cancel();
    _routeTimer?.cancel();
    _workoutPhase = WorkoutPhase.idle;
    _startPosition = null;
    _endPosition = null;
    _currentPosition = null;
    _routePoints = [];
    _distanceMeters = 0.0;
    _startTime = null;
    _elapsedSeconds = 0;
    _errorMessage = null;
    _isLoadingLocation = false;
    notifyListeners();
  }

  // DISTANCE CALCULATIONS

  double calculateRouteDistance() {
    if (_routePoints.length < 2) return 0;
    double total = 0;
    for (int i = 0; i < _routePoints.length - 1; i++) {
      final p1 = _routePoints[i];
      final p2 = _routePoints[i + 1];
      total += _locationService.calculateDistance(
        p1.latitude,
        p1.longitude,
        p2.latitude,
        p2.longitude,
      );
    }
    return total;
  }

  double calculateStraightDistance() {
    if (_routePoints.length < 2) return 0;
    final start = _routePoints.first;
    final end = _routePoints.last;
    return _locationService.calculateDistance(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  @override
  void dispose() {
    _workoutTimer?.cancel();
    _routeTimer?.cancel();
    super.dispose();
  }
}
