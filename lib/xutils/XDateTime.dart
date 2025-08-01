import 'dart:developer';
import 'package:flutter/material.dart';

class XDateTime{
  String toTimeString(TimeOfDay time) {
    //convert 24 hour into 12 hour format

    int hourInt = time.hour;
    if (hourInt > 12) {
      hourInt -= 12;
    } else if (hourInt == 0) {
      hourInt = 12; // Midnight case
    }

    String hourString = hourInt.toString().padLeft(2, '0');

    //getting am or pm
    String amPm = time.hour >= 12 ? 'PM' : 'AM';



    return "$hourString:${time.minute.toString().padLeft(2, '0')} $amPm";
  }

  TimeOfDay toTimeOfDay(String timeString) {
    // Example: "02:30 PM"
    List<String> dateTimeParts = timeString.split(':');
    if (dateTimeParts.length != 2) {
      throw FormatException("Invalid time format");
    }

    int hour = int.parse(dateTimeParts[0]);

    if (hour < 1 || hour > 12) {
      throw FormatException("Hour must be between 1 and 12");
    }

    List<String> minuteParts = dateTimeParts[1].split(' ');
    int minute = int.parse(minuteParts[0]);
    String amPm = minuteParts[1].toUpperCase();

    if (amPm == 'PM' && hour < 12) {
      hour += 12; // Convert PM to 24-hour format
    } else if (amPm == 'AM' && hour == 12) {
      hour = 0; // Midnight case
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  DateTime toDate(String dateString) {
    // Example: "January 1, 2023"
    List<String> dateParts = dateString.split(' ');
    if (dateParts.length != 3) {
      throw FormatException("Invalid date format");
    }

    String monthName = dateParts[0];
    int day = int.parse(dateParts[1].replaceAll(',', ''));
    int year = int.parse(dateParts[2]);

    int monthNumber = getMonthNumber(monthName);
    if (monthNumber == -1) {
      throw FormatException("Invalid month name");
    }

    return DateTime(year, monthNumber, day);
  }

  DateTime toDateTime(String dateString, String timeString) {
    DateTime date = toDate(dateString);
    TimeOfDay time = toTimeOfDay(timeString);

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String toDateString(DateTime date) {
    return "${getMonthName(date.month)} ${date.day}, ${date.year}";
  }

  List<String> get _monthNames => [
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
    'December'
  ];

  String getMonthName(int monthNumber) {
    List<String> months = _monthNames;

    if (monthNumber < 1 || monthNumber > 12) return 'Invalid month';
    return months[monthNumber - 1];
  }

  int getMonthNumber(String monthName) {
    List<String> months = _monthNames;

    monthName = monthName.toLowerCase();
    for (int i = 0; i < months.length; i++) {
      if (months[i].toLowerCase() == monthName) {
        return i + 1; // Months are 1-indexed
      }
    }
    return -1; // Invalid month name
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
}