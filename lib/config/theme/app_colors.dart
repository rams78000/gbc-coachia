import 'package:flutter/material.dart';

/// Couleurs de l'application
class AppColors {
  /// Constructeur privé
  const AppColors._();

  /// Couleurs primaires
  static const Color primaryLight = Color(0xFF3F51B5);  // Indigo
  static const Color primaryDark = Color(0xFF3949AB);   // Indigo plus foncé
  
  /// Couleurs secondaires
  static const Color secondaryLight = Color(0xFF4CAF50);  // Vert
  static const Color secondaryDark = Color(0xFF388E3C);   // Vert plus foncé
  
  /// Couleurs d'accentuation
  static const Color accentLight = Color(0xFFFFA000);  // Ambre
  static const Color accentDark = Color(0xFFFF6F00);   // Ambre plus foncé
  
  /// Couleurs de texte
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  
  /// Couleurs de fond
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  
  /// Couleurs d'erreur
  static const Color errorLight = Color(0xFFD32F2F);
  static const Color errorDark = Color(0xFFEF5350);
  
  /// Couleurs de succès
  static const Color successLight = Color(0xFF388E3C);
  static const Color successDark = Color(0xFF4CAF50);
  
  /// Couleurs d'avertissement
  static const Color warningLight = Color(0xFFFFA000);
  static const Color warningDark = Color(0xFFFFB74D);
  
  /// Couleurs pour le thème clair
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryLight,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE8EAF6),
    onPrimaryContainer: Color(0xFF3F51B5),
    secondary: secondaryLight,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE8F5E9),
    onSecondaryContainer: Color(0xFF388E3C),
    tertiary: accentLight,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFFECB3),
    onTertiaryContainer: Color(0xFFFF6F00),
    error: errorLight,
    onError: Colors.white,
    errorContainer: Color(0xFFFFEBEE),
    onErrorContainer: Color(0xFFD32F2F),
    background: backgroundLight,
    onBackground: textPrimaryLight,
    surface: Colors.white,
    onSurface: textPrimaryLight,
    surfaceVariant: Color(0xFFEEEEEE),
    onSurfaceVariant: textSecondaryLight,
    outline: Color(0xFFBDBDBD),
    outlineVariant: Color(0xFFE0E0E0),
    shadow: Colors.black.withOpacity(0.1),
    scrim: Colors.black.withOpacity(0.3),
    inverseSurface: Color(0xFF212121),
    onInverseSurface: Colors.white,
    inversePrimary: Color(0xFF9FA8DA),
  );

  /// Couleurs pour le thème sombre
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryDark,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF303F9F),
    onPrimaryContainer: Colors.white,
    secondary: secondaryDark,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF1B5E20),
    onSecondaryContainer: Colors.white,
    tertiary: accentDark,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFE65100),
    onTertiaryContainer: Colors.white,
    error: errorDark,
    onError: Colors.white,
    errorContainer: Color(0xFFB71C1C),
    onErrorContainer: Colors.white,
    background: backgroundDark,
    onBackground: textPrimaryDark,
    surface: Color(0xFF1E1E1E),
    onSurface: textPrimaryDark,
    surfaceVariant: Color(0xFF2C2C2C),
    onSurfaceVariant: textSecondaryDark,
    outline: Color(0xFF494949),
    outlineVariant: Color(0xFF333333),
    shadow: Colors.black.withOpacity(0.2),
    scrim: Colors.black.withOpacity(0.5),
    inverseSurface: Colors.white,
    onInverseSurface: Color(0xFF212121),
    inversePrimary: Color(0xFF3F51B5),
  );
}
