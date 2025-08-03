import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sufiyana_kaam/models/process-task.dart';
import 'package:sufiyana_kaam/services/database-services.dart';
import 'package:sufiyana_kaam/xutils/XDateTime.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import 'package:sufiyana_kaam/models/process.dart' as process;
import '../xutils/assets.dart';

class NotificationService {
  Future<void> init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();


    var initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher")
    );
    

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        // ...
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<void> _showScheduledNotification(
      int id, String title, String body, DateTime dateTime) async {

    const NotificationDetails notificationDetails =
        NotificationDetails(android: AndroidNotificationDetails(
          'scheduled_id',
          'scheduled_channel',
          channelDescription: 'Scheduled Channel Description',
          importance: Importance.max,
          priority: Priority.high,

        ));

    tz.initializeTimeZones();
    final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);


    await FlutterLocalNotificationsPlugin().zonedSchedule(
      id,
      title,
      body,
      androidScheduleMode: AndroidScheduleMode.exact,
      scheduledDate,
      notificationDetails,
    );
  }

  Future<void> _showAlaramNotification(
      int id, String title, String body, tz.TZDateTime dateTime) async {

    NotificationDetails notificationDetails =
    NotificationDetails(android: AndroidNotificationDetails(
      'scheduled_id',
      'scheduled_channel',
      channelDescription: 'Scheduled Channel Description',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound("alaram"), // Custom sound
      fullScreenIntent: true, // Full screen intent for alarms
        enableLights: true,
      enableVibration: true,
      playSound: true,
      autoCancel: false,
      actions: [
        AndroidNotificationAction(
          'Dismiss',
          'Dismiss',
          cancelNotification: true,
        ),
      ]
      ),
    );

    await FlutterLocalNotificationsPlugin().zonedSchedule(
      id,
      title,
      body,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      dateTime,
      notificationDetails,
    );
  }

  Future<void> scheduleNotificationBasedOnPriority(ProcessTask task) async {
    if(task.priority == process.Priority().normal){
      await scheduleNotification(task);
    } else if(task.priority == process.Priority().high){
      await scheduleAlaram(task);
    }else{
      await cancelNotification(task.id ?? 0);
    }
  }

  Future<void> scheduleNotification(ProcessTask task) async {
    tz.TZDateTime? dateTime = _convertDateTimeToTZDateTime(task.date.date, task.time);

    if(dateTime == null){
      return; // If date or time is not provided, we don't schedule a notification
    }

    await _showScheduledNotification(
      task.id ?? 0, // Use task.id or default to 0
      task.title,
      task.description,
      dateTime,
    );
  }

  Future<void> scheduleAlaram(ProcessTask task) async {

    tz.TZDateTime? dateTime = _convertDateTimeToTZDateTime(task.date.date, task.time);

    if(dateTime == null){
      return; // If date or time is not provided, we don't schedule a notification
    }

    await _showAlaramNotification(
      task.id ?? 0, // Use task.id or default to 0
      task.title,
      task.description,
      dateTime,
    );
  }

  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'Test Id',
      'Test Channel',
      channelDescription: 'Test Channel Description',
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
        0, 'This is Title', 'This is body', notificationDetails);
  }

  tz.TZDateTime? _convertDateTimeToTZDateTime(String? date, String? time) {
    date = date ?? "";
    if(date.trim().isEmpty){
      return null; // If date is not provided, we don't schedule a notification
    }

    time = time ?? '';
    if(time.trim().isEmpty){
      time = "07:00 AM"; // Default time if not provided
    }

    DateTime dateTime = XDateTime().toDateTime(date, time);

    tz.initializeTimeZones();
    final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);
    return scheduledDate;
  }

  Future<void> cancelNotification(int id) async {
    await FlutterLocalNotificationsPlugin().cancel(id);
  }

  Future<void> cancelAllNotificationsForProcess(int processId) async {
    List<ProcessTask> processes = await DatabaseServices.create().fetchProcessTasks(processId);
    for (ProcessTask task in processes) {
      if (task.id != null) {
        await cancelNotification(task.id!);
      }
    }
  }
}