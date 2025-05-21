import 'package:flutter/material.dart';

/// App theme configuration with light and dark themes
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // Define brand colors
  static const Color primaryColor = Color(0xFF4A6FE6);
  static const Color secondaryColor = Color(0xFF8C61FF);
  static const Color accentColor = Color(0xFF42E8A3);

  // Light theme colors
  static const Color lightBackground = Color(0xFFF8F9FC);
  static const Color lightSurface = Colors.white;
  static const Color lightText = Color(0xFF2C2E43);
  static const Color lightSecondaryText = Color(0xFF666B8C);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF1A1C2D);
  static const Color darkSurface = Color(0xFF252738);
  static const Color darkText = Color(0xFFF4F5FC);
  static const Color darkSecondaryText = Color(0xFFAEB3D2);

  // Message colors
  static const Color userBubbleColor = primaryColor;
  static const Color aiBubbleColor = Color(0xFFE9ECFC);
  static const Color darkAiBubbleColor = Color(0xFF333649);

  // Light theme definition
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      background: lightBackground,
      surface: lightSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: lightText,
      onSurface: lightText,
    ),
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: lightText,
      elevation: 0,
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: lightText),
      displayMedium: TextStyle(color: lightText),
      displaySmall: TextStyle(color: lightText),
      headlineMedium: TextStyle(color: lightText),
      headlineSmall: TextStyle(color: lightText),
      titleLarge: TextStyle(color: lightText),
      titleMedium: TextStyle(color: lightText),
      titleSmall: TextStyle(color: lightText),
      bodyLarge: TextStyle(color: lightText),
      bodyMedium: TextStyle(color: lightText),
      bodySmall: TextStyle(color: lightSecondaryText),
      labelLarge: TextStyle(color: lightText),
      labelSmall: TextStyle(color: lightSecondaryText),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    ),
  );

  // Dark theme definition
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      background: darkBackground,
      surface: darkSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: darkText,
      onSurface: darkText,
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkText,
      elevation: 0,
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: darkText),
      displayMedium: TextStyle(color: darkText),
      displaySmall: TextStyle(color: darkText),
      headlineMedium: TextStyle(color: darkText),
      headlineSmall: TextStyle(color: darkText),
      titleLarge: TextStyle(color: darkText),
      titleMedium: TextStyle(color: darkText),
      titleSmall: TextStyle(color: darkText),
      bodyLarge: TextStyle(color: darkText),
      bodyMedium: TextStyle(color: darkText),
      bodySmall: TextStyle(color: darkSecondaryText),
      labelLarge: TextStyle(color: darkText),
      labelSmall: TextStyle(color: darkSecondaryText),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color(0xFF333649),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    ),
  );
}