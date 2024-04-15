import 'dart:ui';

import 'package:flutter/material.dart';

class AppTextTheme{
  static TextTheme textTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: 24.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 14.0,
      color: Colors.black,
    ),
  );
}