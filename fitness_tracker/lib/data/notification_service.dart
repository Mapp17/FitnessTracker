import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _plugin.initialize(initializationSettings);

    // Request permission for Android 13+
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    _isInitialized = true;
  }

  Future<void> showWorkoutCompleteAlert({
    required String workoutName,
    double? distanceKm,
    Duration? duration,
    String? pace,
    String? stats,
  }) async {
    String title = 'Workout Complete!';
    String body = stats ?? '$workoutName complete! Keep the streak alive.';

    // Intelligent content logic
    if (distanceKm != null && duration != null) {
      final timeStr = _formatDuration(duration);
      if (distanceKm > 5) {
        body = 'Amazing endurance! You covered ${distanceKm.toStringAsFixed(2)} km in $timeStr.';
      } else if (distanceKm > 2) {
        body = 'Solid run! ${distanceKm.toStringAsFixed(2)} km at ${pace ?? "steady"} pace.';
      } else if (distanceKm > 0) {
        body = 'Every step counts! You ran ${distanceKm.toStringAsFixed(2)} km today.';
      }
    } else if (duration != null && duration.inMinutes >= 30) {
      body = '30+ minutes of work! $workoutName is done.';
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'workout_complete',
      'Workout Completion',
      channelDescription: 'Notifications for completed workouts',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _plugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    if (d.inHours > 0) {
      return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> showReminderNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reminders',
      'Reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _plugin.show(
      1,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
