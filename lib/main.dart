import 'package:flutter/material.dart';
import 'package:sufiyana_kaam/services/database-services.dart';
import 'package:sufiyana_kaam/view/TestScreen.dart';
import 'package:sufiyana_kaam/view/create-process-task-view.dart';
import 'package:sufiyana_kaam/view/home.dart';
import 'package:sufiyana_kaam/view/note_screen.dart';
import 'package:sufiyana_kaam/xutils/GlobalContext.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseServices.create().init();
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
    );
  }
}

