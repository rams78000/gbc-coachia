import 'package:flutter/material.dart';

/// Configuration du thème de l'application
class AppTheme {
  /// Schéma de couleurs light
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF0066CC), // Bleu primaire
    secondary: const Color(0xFF4CAF50), // Vert secondaire
    tertiary: const Color(0xFFFF9800), // Orange
    error: const Color(0xFFE53935), // Rouge
    brightness: Brightness.light,
  );

  /// Schéma de couleurs dark
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF0066CC), // Bleu primaire
    secondary: const Color(0xFF4CAF50), // Vert secondaire
    tertiary: const Color(0xFFFF9800), // Orange
    error: const Color(0xFFE53935), // Rouge
    brightness: Brightness.dark,
  );

  /// Thème light
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: lightColorScheme.primary,
      ),
      titleTextStyle: TextStyle(
        color: lightColorScheme.primary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightColorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: lightColorScheme.primaryContainer,
      labelTextStyle: MaterialStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight:
              states.contains(MaterialState.selected) ? FontWeight.bold : null,
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  /// Thème dark
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: darkColorScheme.primary,
      ),
      titleTextStyle: TextStyle(
        color: darkColorScheme.primary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkColorScheme.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: darkColorScheme.primaryContainer,
      labelTextStyle: MaterialStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight:
              states.contains(MaterialState.selected) ? FontWeight.bold : null,
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
