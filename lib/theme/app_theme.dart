import 'package:flutter/material.dart';

/// Extension to access custom colors from Theme
extension AppColors on ColorScheme {
  Color get success => brightness == Brightness.light
      ? AppTheme.successColor
      : AppTheme.successColorDark;

  Color get onSuccess => brightness == Brightness.light
      ? Colors.white
      : Colors.black;

  Color get warning => brightness == Brightness.light
      ? AppTheme.warningColor
      : AppTheme.warningColorDark;

  Color get placeholder => brightness == Brightness.light
      ? AppTheme.greyLight
      : AppTheme.greyDark;

  Color get placeholderIcon => brightness == Brightness.light
      ? AppTheme.greyDark
      : AppTheme.greyMedium;
}

/// App theme configuration with Material 3 design.
class AppTheme {
  /// Primary color scheme inspired by climbing/outdoor theme.
  static const Color primaryColor = Color(0xFF8B4513); // Saddle brown
  static const Color secondaryColor = Color(0xFFD2691E); // Chocolate
  static const Color accentColor = Color(0xFFCD853F); // Peru
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Colors.white;
  
  // Semantic colors for light theme
  static const Color errorColor = Color(0xFFD32F2F); // Material red 700
  static const Color successColor = Color(0xFF388E3C); // Material green 700
  static const Color warningColor = Color(0xFFF57C00); // Material orange 700
  
  // Semantic colors for dark theme
  static const Color errorColorDark = Color(0xFFEF5350); // Material red 400
  static const Color successColorDark = Color(0xFF66BB6A); // Material green 400
  static const Color warningColorDark = Color(0xFFFF9800); // Material orange 400
  
  // Neutral colors
  static const Color greyLight = Color(0xFFEEEEEE); // Grey 200
  static const Color greyMedium = Color(0xFFBDBDBD); // Grey 400
  static const Color grey = Color(0xFF9E9E9E); // Grey 500
  static const Color greyDark = Color(0xFF757575); // Grey 600
  static const Color greyDarker = Color(0xFF424242); // Grey 800
  
  // Special colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  
  // Dark mode background
  static const Color darkBackground = Color(0xFF121212);

  /// Creates the light theme for the app.
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: surfaceColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
      ),
      typography: Typography.material2021(),
    );
  }

  /// Creates the dark theme for the app (optional, for future use).
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      // surface: Color.fromARGB(255, 28, 20, 0)
      surface: Color.fromARGB(255, 34, 28, 20)
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkBackground,
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: colorScheme.surface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 4,
      ),
      typography: Typography.material2021(),
    );
  }
}

