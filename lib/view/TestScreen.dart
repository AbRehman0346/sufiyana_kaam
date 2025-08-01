import 'package:flutter/material.dart';
import 'package:sufiyana_kaam/models/process-task.dart';
import 'package:sufiyana_kaam/services/notification_service.dart';
import 'package:sufiyana_kaam/xutils/XDateTime.dart';
import 'package:sufiyana_kaam/xutils/widgets/xtext.dart';

import '../models/process.dart';
import '../xutils/widgets/utils.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: XText("Testing"),
      ),

      body: SingleChildScrollView(
        child: SizedBox(
          height: Utils.screenBodyHeight,
          child: Center(
            child: ElevatedButton(onPressed: _showNotification, child: XText("Show Notification")),
          ),
        ),
      ),
    );
  }

  Future<void> _showNotification() async {
    DateTime dateTime = DateTime.now().add(Duration(minutes: 1));
    TimeOfDay time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    ProcessTask task = ProcessTask(
      id: 1,
      title: "Test Task",
      description: "This is a test task",
      date: XDateTime().toDateString(dateTime),
      time: XDateTime().toTimeString(time),
      order: 1,
      priority: Priority().normal,
      processId: 1,
      status: ProcessTaskStatus.completed,
    );
    await NotificationService().scheduleAlaram(task);
  }

}
