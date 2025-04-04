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
  static final ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryLight,
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFE8EAF6),
    onPrimaryContainer: const Color(0xFF3F51B5),
    secondary: secondaryLight,
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFE8F5E9),
    onSecondaryContainer: const Color(0xFF388E3C),
    tertiary: accentLight,
    onTertiary: Colors.white,
    tertiaryContainer: const Color(0xFFFFECB3),
    onTertiaryContainer: const Color(0xFFFF6F00),
    error: errorLight,
    onError: Colors.white,
    errorContainer: const Color(0xFFFFEBEE),
    onErrorContainer: const Color(0xFFD32F2F),
    surface: Colors.white,
    onSurface: textPrimaryLight,
    surfaceContainerHighest: const Color(0xFFEEEEEE),
    onSurfaceVariant: textSecondaryLight,
    outline: const Color(0xFFBDBDBD),
    outlineVariant: const Color(0xFFE0E0E0),
    shadow: Colors.black.withOpacity(0.1),
    scrim: Colors.black.withOpacity(0.3),
    inverseSurface: const Color(0xFF212121),
    onInverseSurface: Colors.white,
    inversePrimary: const Color(0xFF9FA8DA),
  );

  /// Couleurs pour le thème sombre
  static final ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryDark,
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFF303F9F),
    onPrimaryContainer: Colors.white,
    secondary: secondaryDark,
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFF1B5E20),
    onSecondaryContainer: Colors.white,
    tertiary: accentDark,
    onTertiary: Colors.white,
    tertiaryContainer: const Color(0xFFE65100),
    onTertiaryContainer: Colors.white,
    error: errorDark,
    onError: Colors.white,
    errorContainer: const Color(0xFFB71C1C),
    onErrorContainer: Colors.white,
    surface: const Color(0xFF1E1E1E),
    onSurface: textPrimaryDark,
    surfaceContainerHighest: const Color(0xFF2C2C2C),
    onSurfaceVariant: textSecondaryDark,
    outline: const Color(0xFF494949),
    outlineVariant: const Color(0xFF333333),
    shadow: Colors.black.withOpacity(0.2),
    scrim: Colors.black.withOpacity(0.5),
    inverseSurface: Colors.white,
    onInverseSurface: const Color(0xFF212121),
    inversePrimary: const Color(0xFF3F51B5),
  );
}
