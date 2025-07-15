import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sufiyana_kaam/view/create-process-task-view.dart';
import 'package:sufiyana_kaam/view/home.dart';
import 'package:sufiyana_kaam/view/note_screen.dart';

import 'models/process.dart';

class Routes{
  static const String home = '/';
  static const String noteScreen = '/noteScreen';
  // static const String createProcessTask = '/createProcessTask';
  static const String error = '/error';
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