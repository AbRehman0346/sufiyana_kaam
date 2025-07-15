import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sufiyana_kaam/route-generator.dart';
import 'package:sufiyana_kaam/xutils/widgets/xtext.dart';

import '../GlobalContext.dart';

class Utils {
  static Widget height(double height) {
    return SizedBox(height: height);
  }

  static Widget width(double width) {
    return SizedBox(width: width);
  }

  static double get screenHeight =>
      MediaQuery.of(GlobalContext.getContext).size.height;

  static double get screenBodyHeight =>
      MediaQuery.of(GlobalContext.getContext).size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(GlobalContext.getContext).padding.top -
      MediaQuery.of(GlobalContext.getContext).padding.bottom;

  static double get screenWidth =>
      MediaQuery.of(GlobalContext.getContext).size.width;

  void showBottomSheet({
    required List<Widget> children,
    bool handleScrolling = false,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    Color bgColor = Colors.white,
  }) {
    BuildContext context = GlobalContext.getContext;
    showModalBottomSheet(
      isScrollControlled: handleScrolling,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: bgColor,
      builder: (BuildContext context) {
        return Container(
          width: Utils.screenWidth,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          ),
        );
      },
    );
  }

  Future<DateTime?> selectDate(
    BuildContext context, {
    String helpText = "Select Date",
  }) async {
    var datetime = await showDialog(
      context: context,
      builder: (context) {
        return DatePickerDialog(
          firstDate: DateTime(1950),
          lastDate: DateTime(2070),
          initialDate: DateTime.now(),
          helpText: helpText,
        );
      },
    );
    return datetime;
  }

  String toStringTime(TimeOfDay time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  String toStringDate(DateTime date) {
    return "${Utils().getMonthName(date.month)} ${date.day}, ${date.year}";
  }

  Future<TimeOfDay?> selectTime(
    BuildContext context, {
    String helpText = "Select Time",
  }) async {
    TimeOfDay timeofDay = await showDialog(
      context: context,
      builder: (context) {
        return TimePickerDialog(
          initialTime: TimeOfDay(hour: 12, minute: 00),
          helpText: helpText,
        );
      },
    );
    return timeofDay;
  }

  String getMonthName(int monthNumber) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    if (monthNumber < 1 || monthNumber > 12) return 'Invalid month';
    return months[monthNumber - 1];
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showProgressBar({String? msg}) {
    showDialog(
      barrierDismissible: false,
      context: GlobalContext.getContext,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            if (msg != null) const SizedBox(height: 20),
            if (msg != null)
              XText(msg, bold: true, size: 15, color: Colors.white),
          ],
        ),
      ),
    );
  }

  static void hideProgressBar() {
    Navigator.pop(GlobalContext.getContext);
  }

  void showOKDialog(String title, String content) {
    showDialog(
      context: GlobalContext.getContext,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(GlobalContext.getContext);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
