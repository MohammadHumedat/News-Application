import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get mainTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  );
  static ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      iconColor: Colors.white,
    ),
  );
}
