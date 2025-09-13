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
      style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
    ),
    textTheme: ThemeData.light().textTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    // Build a color scheme and then make sure surface/background/on* colors are explicit
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF121326),
          background: const Color(0xFF0B1020),
          onSurface: Colors.white,
          onBackground: Colors.white,
          onPrimary: Colors.white,
        ),
    primaryColor: primaryColor,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0B1020),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0B1020),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: primaryColor),
    ),
    cardColor: const Color(0xFF121326),
    dividerColor: Colors.grey[600],
    shadowColor: Colors.black.withOpacity(0.6),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    // Ensure text defaults to white in dark mode
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
