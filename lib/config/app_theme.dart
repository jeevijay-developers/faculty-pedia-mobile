// lib/config/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static final Color primaryColor = const Color(0xFF4A90E2);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: primaryColor),
    ),
    cardColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: ThemeData.light().textTheme,
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      disabledColor: Colors.grey.withOpacity(0.5),
      selectedColor: primaryColor,
      secondarySelectedColor: primaryColor,
      labelStyle: TextStyle(color: primaryColor),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      side: BorderSide(color: primaryColor),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ).copyWith(
      surface: const Color(0xFF1A1A2E),
      background: const Color(0xFF161625),
      onSurface: Colors.white,
      onBackground: Colors.white,
      onPrimary: Colors.white,
    ),
    primaryColor: primaryColor,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF161625),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF161625),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: primaryColor),
    ),
    cardColor: const Color(0xFF1A1A2E),
    dividerColor: Colors.grey[800],
    shadowColor: Colors.black.withOpacity(0.4),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
    iconTheme: const IconThemeData(color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey[400]),
      hintStyle: TextStyle(color: Colors.grey[500]),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1A1A2E),
      disabledColor: Colors.grey.withOpacity(0.5),
      selectedColor: primaryColor,
      secondarySelectedColor: primaryColor,
      labelStyle: const TextStyle(color: Colors.white),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      side: BorderSide(color: primaryColor),
    ),
  );
}