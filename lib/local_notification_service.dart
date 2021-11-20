import 'dart:io';
import 'dart:math';

import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future dailyAtTimeNotification(int afterSeconds) async {
  final notiTitle = 'title';
  final notiDesc = 'description';
  
  print('<=== [dailyAtTimeNotification] Section 1');
  
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final result = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  var android = AndroidNotificationDetails('id', notiTitle, 
      channelDescription: notiDesc,
      importance: Importance.max, priority: Priority.max);
  var ios = IOSNotificationDetails();
  var detail = NotificationDetails(android: android, iOS: ios);

  if (Platform.isAndroid || (Platform.isIOS && result != null && result == true)) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup('id');

    print('<=== [dailyAtTimeNotification] Section 2');
        
    await flutterLocalNotificationsPlugin.zonedSchedule(
      Random().nextInt(1000), // id should be unique
      notiTitle,
      notiDesc,
      await _setNotiTime(afterSeconds),
      detail,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print('<=== [dailyAtTimeNotification] Section 3');
  }
}

Future<tz.TZDateTime> _setNotiTime(int afterSeconds) async {
  tz.initializeTimeZones();
  tz.setLocalLocation(
    tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
  //tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

  final now = tz.TZDateTime.now(tz.local);
  var scheduledDate = now.add(Duration(seconds: afterSeconds));

  return scheduledDate;
}