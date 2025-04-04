import 'package:flutter/material.dart';

/// Thème de l'application
class AppTheme {
  // Constantes de couleurs de la charte graphique
  static const primaryColor = Color(0xFFB87333);    // Cuivre/bronze
  static const secondaryColor = Color(0xFFFFD700);  // Or
  static const accentColor = Color(0xFFB87333);     // Variante du cuivre/bronze
  static const backgroundColorLight = Color(0xFFF5F7FA);
  static const backgroundColorDark = Color(0xFF1A1C2E);
  static const textColorLight = Color(0xFF1F2937);
  static const textColorDark = Color(0xFFF9FAFB);
  static const errorColor = Color(0xFFEF4444);
  static const successColor = Color(0xFF22C55E);
  static const warningColor = Color(0xFFF59E0B);
  static const infoColor = Color(0xFF0EA5E9);

  // Constantes pour le texte secondaire
  static const textSecondaryColor = Color(0xFF6B7280);

  // Constantes d'espacement
  static const double spacing1x = 8.0;
  static const double spacing2x = 16.0;
  static const double spacing3x = 24.0;
  static const double spacing4x = 32.0;
  
  // Aliases pour compatibilité
  static const double smallSpacing = spacing1x;
  static const double spacing = spacing2x;
  static const double largeSpacing = spacing3x;
  static const double extraLargeSpacing = spacing4x;

  // Constantes de bordures
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;
  
  // Aliases pour compatibilité
  static const double smallBorderRadius = borderRadiusSmall;
  static const double borderRadius = borderRadiusMedium;
  static const double largeBorderRadius = borderRadiusLarge;
  static const double extraLargeBorderRadius = borderRadiusXLarge;

  // Ombres
  static List<BoxShadow> get defaultShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];

  /// Thème clair
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      // Utiliser surface au lieu de background
      surface: backgroundColorLight,
      secondary: secondaryColor,
    ),
    scaffoldBackgroundColor: backgroundColorLight,
    textTheme: _buildTextTheme(Brightness.light),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: textColorLight,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing,
        vertical: spacing,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: spacing,
          vertical: spacing,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing,
          vertical: spacing,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: primaryColor.withOpacity(0.8),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: secondaryColor,
    ),
  );

  /// Thème sombre
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      // Utiliser surface au lieu de background
      surface: backgroundColorDark,
      secondary: secondaryColor,
    ),
    scaffoldBackgroundColor: backgroundColorDark,
    textTheme: _buildTextTheme(Brightness.dark),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: backgroundColorDark,
      foregroundColor: textColorDark,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2D3E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: Colors.grey.shade700,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: Colors.grey.shade700,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing,
        vertical: spacing,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: spacing,
          vertical: spacing,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing,
          vertical: spacing,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: primaryColor.withOpacity(0.8),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: secondaryColor,
    ),
  );

  static TextTheme _buildTextTheme(Brightness brightness) {
    final Color textColor =
        brightness == Brightness.light ? textColorLight : textColorDark;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: 'Inter',
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: 'Inter',
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: 'Inter',
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: 'Inter',
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: 'Inter',
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: 'Inter',
      ),
      titleLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: 'Inter',
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: 'Inter',
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: textColor,
        fontFamily: 'Inter',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textColor,
        fontFamily: 'Inter',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textColor,
        fontFamily: 'Inter',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: textColor.withOpacity(0.7),
        fontFamily: 'Inter',
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: 'Inter',
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: 'Inter',
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textColor,
        fontFamily: 'Inter',
      ),
    );
  }
}
