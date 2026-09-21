import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final instance = NotificationService._();
  static const _channelId = 'water_reminders';
  static const _channelName = 'Water reminders';
  static const _reminderIdStart = 1000;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(
      android: android,
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(settings);
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
    _initialized = true;
  }

  Future<void> scheduleWaterReminders() async {
    await init();
    await cancelWaterReminders();
    final now = tz.TZDateTime.now(tz.local);
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Gentle reminders to drink water.',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        sound: RawResourceAndroidNotificationSound('water_drop'),
      ),
      iOS: DarwinNotificationDetails(),
    );
    var id = _reminderIdStart;
    for (var hour = 9; hour <= 21; hour += 2) {
      var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      try {
        await _plugin.zonedSchedule(
          id++,
          'Time for water',
          'Add a glass of water to PlateWise.',
          scheduled,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (error) {
        debugPrint('Unable to schedule water reminder: $error');
      }
    }
  }

  Future<void> cancelWaterReminders() async {
    for (var id = _reminderIdStart; id < _reminderIdStart + 8; id++) {
      await _plugin.cancel(id);
    }
  }
}
