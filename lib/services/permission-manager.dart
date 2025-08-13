import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
class PermissionManager {
  // Singleton instance
  static final PermissionManager _instance = PermissionManager._internal();

  // Private constructor
  PermissionManager._internal();

  // Factory constructor to return the singleton instance
  factory PermissionManager() {
    return _instance;
  }

  Future<void> requestPermissions() async {
    await requestExectAlaramPermission();
    await ignoreBatteryOptimization();
  }

  Future<bool> requestManageExternalStoragePermission() async {
    PermissionStatus permission = await Permission.manageExternalStorage.request();
    // log("------------Permission to storage: ${permission.isGranted}");
    return permission.isGranted;
  }

  Future<bool> requestExectAlaramPermission() async {
    PermissionStatus permission = await Permission.scheduleExactAlarm.request();
    // log("------------Permission to schedule exact alarms: ${permission.isGranted}");
    return permission.isGranted;
  }

  Future<bool> ignoreBatteryOptimization() async {
    if (await Permission.ignoreBatteryOptimizations.isGranted) {
      // log("------------Permission to Battery Optimization: true");
      return true;
    }

    // Request permission to ignore battery optimizations
    PermissionStatus status = await Permission.ignoreBatteryOptimizations.request();
    // log("------------Permission to Battery Optimization: ${status.isGranted}");
    return status.isGranted;
  }
}