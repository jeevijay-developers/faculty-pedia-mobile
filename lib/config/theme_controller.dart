              import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

  static Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('theme') ?? 'Light';
    themeMode.value = _themeModeFromString(stored);
  }

  static Future<void> setThemeFromString(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    themeMode.value = _themeModeFromString(theme);
  }

  static ThemeMode _themeModeFromString(String theme) {
    switch (theme) {
      case 'Dark':
        return ThemeMode.dark;
      case 'System':
        return ThemeMode.system;
      case 'Light':
      default:
        return ThemeMode.light;
    }
  }
}
