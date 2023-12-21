import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = (duration.inMinutes % 60).toInt();

  String formattedDuration = '$hours h $minutes min';
  return formattedDuration;
}

// Stub but will help consistency.
String formatDate(DateTime date) {
  return DateFormat('MMMM d, y').format(date);
}

/// Returns a formatted string. Accepts a TimeOfDay or DateTime, defaulting to the former if both are given.
String formatTime({TimeOfDay? time, DateTime? dateTime}) {
  NumberFormat formatter = NumberFormat("00");
  int hour;
  int minute;

  if (time != null) {
    hour = time.hour;
    minute = time.minute;
  } else if (dateTime != null) {
    hour = dateTime.hour;
    minute = dateTime.minute;
  } else {
    return "";
  }

  bool pm = hour > 12;
  if (pm) hour -= 12;

  return "${formatter.format(hour)}:${formatter.format(minute)} ${pm ? "PM" : "AM"}";
}
