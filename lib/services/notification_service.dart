import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    if (kIsWeb) return;

    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);

    final androidPlugin =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> showTestNotification() async {
    if (kIsWeb) return;

    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Channel for test notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _plugin.show(
      0,
      'Silent Scheduler',
      'This is a test notification.',
      const NotificationDetails(android: androidDetails),
    );
  }

  static Future<void> showCustomNotification({
    required String title,
    required String body,
  }) async {
    if (kIsWeb) return;

    const androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Schedule Notifications',
      channelDescription: 'Notifications for schedules',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }

  static Future<void> clearAllNotifications() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }
}