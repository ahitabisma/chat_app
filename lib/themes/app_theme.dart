import 'package:flutter/material.dart';
import 'package:chat_app/themes/dark_theme.dart';
import 'package:chat_app/themes/light_theme.dart';

class AppTheme {
  static ThemeData light() => lightTheme;
  static ThemeData dark() => darkTheme;
}

// Theme Extensions
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  // Colors
  Color get primary => colorScheme.primary;
  Color get onPrimary => colorScheme.onPrimary;
  Color get secondary => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get surface => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;
  Color get error => colorScheme.error;
  Color get onError => colorScheme.onError;
  Color get scaffoldBackground => theme.scaffoldBackgroundColor;
}
