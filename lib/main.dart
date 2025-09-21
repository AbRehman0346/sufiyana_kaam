import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sufiyana_kaam/services/database/database-services.dart';
import 'package:sufiyana_kaam/services/notification_service.dart';
import 'package:sufiyana_kaam/services/permission-manager.dart';
import 'package:sufiyana_kaam/services/version/version.dart';
import 'package:sufiyana_kaam/view/TestScreen.dart';
import 'package:sufiyana_kaam/view/create-task.dart';
import 'package:sufiyana_kaam/view/home/home.dart';
import 'package:sufiyana_kaam/view/note_screen/note_screen.dart';
import 'package:sufiyana_kaam/xutils/GlobalContext.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseServices.create().init();
  await NotificationService().init();
  await PermissionManager().requestPermissions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: GlobalContext.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Home(),
    //   TODO: Change the Alarm Ring to something that can be used for commercialization;
    );
  }
}

