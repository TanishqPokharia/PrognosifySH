import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationServices {
  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
          channelKey: "scheduledNotificationChannelKey",
          channelName: "scheduledNotificationChannel",
          channelDescription: "Provide scheduled Notifications",
          defaultColor: Colors.transparent,
          locked: true,
          importance: NotificationImportance.Max,
          defaultRingtoneType: DefaultRingtoneType.Alarm,
          enableVibration: true,
          playSound: true,
          vibrationPattern: mediumVibrationPattern)
    ]);
  }

  static Future<void> scheduleNotification(
      {required String details,
      required DateTime time,
      required int notificationID}) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationID,
          channelKey: "scheduledNotificationChannelKey",
          title: "Prognosify",
          body: details,
          category: NotificationCategory.Reminder,
          notificationLayout: NotificationLayout.Default,
          locked: true,
          wakeUpScreen: true,
          autoDismissible: false,
          actionType: ActionType.DisabledAction,
          fullScreenIntent: true,
          backgroundColor: Colors.transparent,
        ),
        schedule: NotificationCalendar(
          minute: time.minute,
          hour: time.hour,
          second: time.second,
          day: time.day,
          weekday: time.weekday,
          month: time.month,
          year: time.year,
          preciseAlarm: true,
          allowWhileIdle: true,
          repeats: true,
          timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        ),
        actionButtons: [
          NotificationActionButton(
              key: "CLOSE",
              label: "Okay",
              actionType: ActionType.DisabledAction,
              showInCompactView: true)
        ]);
  }
}
