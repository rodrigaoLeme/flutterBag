import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  colorScheme: const ColorScheme.light().copyWith(
    primary: const Color(0xFF0079b6),
    secondary: Colors.white,
    tertiary: const Color(0xFF0051A1),
    error: const Color(0xFFE62020),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFCCCCCC)),
    ),
  ),
);
