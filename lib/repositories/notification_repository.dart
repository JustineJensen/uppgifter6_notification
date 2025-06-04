import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:uuid/uuid.dart';

class NotificationRepository {
  final FlutterLocalNotificationsPlugin _plugin;
  final Uuid _uuid = const Uuid();

  NotificationRepository(this._plugin);
  
  FlutterLocalNotificationsPlugin get plugin => _plugin;

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> initialize() async {
    await _configureLocalTimeZone();
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      final impl = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await impl?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final impl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await impl?.requestNotificationsPermission();
    }
  }

  Future<void> scheduleParkingReminder({
    required String title,
    required String content,
    required DateTime endTime,
    required int id,
    Duration reminderTime = const Duration(minutes: 15),
  }) async {
    await requestPermissions();
    
    final deliveryTime = endTime.subtract(reminderTime);
    final now = DateTime.now();
    
    if (deliveryTime.isBefore(now)) {
      return; 
    }

    const channelId = 'parking_reminders';
    const channelName = 'Parking Reminders';
    const channelDescription = 'Notifications for parking reminders';

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      channelId, channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      sound: RawResourceAndroidNotificationSound('alert_sound'), 
      playSound: true,
    );

    var darwinPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
    );

    await _plugin.zonedSchedule(
      id,
      title,
      content,
      tz.TZDateTime.from(deliveryTime, tz.local),
      platformChannelSpecifics,
       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
    );
  }

  Future<void> cancelScheduledNotification(int id) async {
    await _plugin.cancel(id);
  }
}