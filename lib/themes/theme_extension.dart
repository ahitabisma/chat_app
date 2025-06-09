import 'package:flutter/material.dart';

extension ThemeColors on BuildContext {
  Color get primary => Theme.of(this).colorScheme.primary;
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;

  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;

  Color get surface => Theme.of(this).colorScheme.surface;
  Color get onSurface => Theme.of(this).colorScheme.onSurface;

  Color get error => Theme.of(this).colorScheme.error;
  Color get onError => Theme.of(this).colorScheme.onError;

  Color get scaffoldBackground => Theme.of(this).scaffoldBackgroundColor;

  Color get appBarBackground =>
      Theme.of(this).appBarTheme.backgroundColor ?? primary;
  Color get appBarForeground =>
      Theme.of(this).appBarTheme.foregroundColor ?? onPrimary;
}
