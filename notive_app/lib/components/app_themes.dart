import 'package:flutter/material.dart';

enum AppTheme { White, Dark, LightGreen, DarkGreen }

/// Returns enum value name without enum class name.
String enumName(AppTheme anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final appThemeData = {
  AppTheme.White:
      ThemeData(brightness: Brightness.light, primaryColor: Colors.white),
  AppTheme.Dark:
      ThemeData(brightness: Brightness.dark, primaryColor: Colors.black)
};
