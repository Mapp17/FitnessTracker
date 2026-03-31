import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Navigates hardware and permission gates to return the current GPS coordinates.
  Future<Position> getCurrentPosition() async {
    // Gate 1: Is GPS hardware enabled?
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
          'Location services are disabled. Please enable GPS in your device settings.');
    }

    // Gate 2: Does this app have permission?
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied. Tap Start Run to try again.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permission is permanently denied. Please enable it in your device settings.');
    }

    // Gate 3: Fetch coordinates
    // If we reach here, permission is granted (whileInUse or always)
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  /// Calculates the distance between two points in meters.
  /// This is a pure calculation and does not require hardware access or permissions.
  double calculateDistance(
      double startLat, double startLon, double endLat, double endLon) {
    return Geolocator.distanceBetween(startLat, startLon, endLat, endLon);
  }
}
