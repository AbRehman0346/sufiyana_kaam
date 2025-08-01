import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sufiyana_kaam/models/process-task.dart';
import 'package:sufiyana_kaam/view/create-task.dart';
import 'package:sufiyana_kaam/view/edit-task.dart';
import 'package:sufiyana_kaam/view/home.dart';
import 'package:sufiyana_kaam/view/note_screen/note_screen.dart';
import 'package:sufiyana_kaam/view/view-task.dart';

import 'models/process.dart';

class Routes{
  static const String home = '/';
  static const String noteScreen = '/noteScreen';
  // static const String createProcessTask = '/createProcessTask';
  static const String error = '/error';
  static const String ViewTask = '/viewTask';
  static const String editTask = '/editTask';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.home: //HomeScreen
        return MaterialPageRoute(builder: (_) => Home());
      case Routes.noteScreen:
        List data = args as List;
        return MaterialPageRoute(builder: (_) => NoteScreen(process: data[0] as Process));
      case Routes.ViewTask:
        List data = args as List;
        return MaterialPageRoute(builder: (_) => ViewTask(
          task: data[0] as ProcessTask,
          onTaskUpdated: data[1] as Function(ProcessTask)?,
        ));
      case Routes.editTask:
        List data = args as List;
        return MaterialPageRoute(builder: (_) => EditTask(
          task: data[0] as ProcessTask,
          onTaskUpdated: data[1] as Function(ProcessTask)?,
      ));
      // case Routes.createProcessTask:
      //   List data = args as List;
      //   return MaterialPageRoute(builder: (_) => CreateProcessTaskView(processId: data[0]));
      default: //Error Screen
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
    }
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Route Couldn't Found!",
        style: TextStyle(fontSize: 20),
        maxLines: 3,
      ),
    );
  }
}