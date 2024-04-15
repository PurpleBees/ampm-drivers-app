import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TimeToFormat on TimeOfDay{
  String get toFormat {
    final DateTime dateTime = DateTime.now().copyWith(hour: hour, minute: minute);
    return DateFormat.jm().format(dateTime);
  }
}