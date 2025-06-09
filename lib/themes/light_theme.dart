import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Color(0xFF1976D2), // biru lebih cerah
    onPrimary: Colors.white,
    secondary: Color(0xFF64B5F6), // biru muda
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    error: Colors.red.shade700,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: Color(0xFFF9FAFB),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1976D2),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFF1976D2), width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.all(16),
  ),
);
