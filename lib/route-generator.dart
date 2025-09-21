import 'package:flutter/material.dart';
import 'package:sufiyana_kaam/models/process-task.dart';
import 'package:sufiyana_kaam/services/version/version.dart';
import 'package:sufiyana_kaam/view/backup-view.dart';
import 'package:sufiyana_kaam/view/edit-task.dart';
import 'package:sufiyana_kaam/view/home/editProcess.dart';
import 'package:sufiyana_kaam/view/home/home.dart';
import 'package:sufiyana_kaam/view/note_screen/note_screen.dart';
import 'package:sufiyana_kaam/view/note_screen/reorder-notes-screen.dart';
import 'package:sufiyana_kaam/view/privacy-policy-view.dart';
import 'package:sufiyana_kaam/view/udpate_app/version-update-screen.dart';
import 'package:sufiyana_kaam/view/view-task.dart';
import 'models/process.dart';

class Routes{
  static const String home = '/';
  static const String noteScreen = '/noteScreen';
  // static const String createProcessTask = '/createProcessTask';
  static const String error = '/error';
  static const String ViewTask = '/viewTask';
  static const String editTask = '/editTask';
  static const String reorderNotesScreen = '/reorderNotesScreen';
  static const String editProcess = "/edit-process";
  static const String backupView = '/backup-view';
  static const String privacyPolicy = '/privacy-policy';
  static const String versionUpdateScreen = "/update-version";
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
      case Routes.reorderNotesScreen:
        List data = args as List;
        Function()? onSortComplete = data.length > 1 ? data[1] as Function()? : null;
        return MaterialPageRoute(builder: (_) => ReorderNotesScreen(process: data[0] as Process, onSortComplete: onSortComplete,));
      case Routes.editProcess:
        List data = args as List;
        Function(bool)? onEdited = data.length > 1 ? data[1] as Function(bool)? : null;
        return MaterialPageRoute(builder: (_) => EditProcess(process: data[0], onProcessEdited: onEdited));
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
      case Routes.backupView: //HomeScreen
        return MaterialPageRoute(builder: (_) => BackupView()
      );
      case Routes.privacyPolicy: //HomeScreen
        return MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()
      );
      case Routes.versionUpdateScreen: //HomeScreen
        return MaterialPageRoute(builder: (_) => VersionUpdateScreen()
      );
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