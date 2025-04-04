import 'package:flutter/material.dart';

/// Classe pour les couleurs de l'application
class AppColors {
  /// Couleur principale
  static const Color primary = Color(0xFF0a58ca);
  
  /// Couleur primaire claire
  static const Color primaryLight = Color(0xFF4283ec);
  
  /// Couleur primaire foncée
  static const Color primaryDark = Color(0xFF0747a1);
  
  /// Couleur secondaire
  static const Color secondary = Color(0xFF6c757d);
  
  /// Couleur secondaire claire
  static const Color secondaryLight = Color(0xFF9ba5ae);
  
  /// Couleur secondaire foncée
  static const Color secondaryDark = Color(0xFF40484e);
  
  /// Couleur de fond
  static const Color background = Colors.white;
  
  /// Couleur de fond pour le mode sombre
  static const Color darkBackground = Color(0xFF121212);
  
  /// Couleur de succès
  static const Color success = Color(0xFF198754);
  
  /// Couleur d'information
  static const Color info = Color(0xFF0dcaf0);
  
  /// Couleur d'avertissement
  static const Color warning = Color(0xFFffc107);
  
  /// Couleur de danger
  static const Color danger = Color(0xFFdc3545);
  
  /// Couleur pour texte
  static const Color textPrimary = Color(0xFF212529);
  
  /// Couleur pour texte secondaire
  static const Color textSecondary = Color(0xFF6c757d);
  
  /// Couleur pour bordures
  static const Color border = Color(0xFFdee2e6);
  
  /// Couleur de surface
  static const Color surface = Color(0xFFf8f9fa);
  
  /// Couleur de surface pour le mode sombre
  static const Color darkSurface = Color(0xFF1E1E1E);
  
  /// Obtient le schéma de couleurs pour le thème clair
  static ColorScheme getLightColorScheme() {
    return ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primaryLight,
      onPrimaryContainer: Colors.white,
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: secondaryLight,
      onSecondaryContainer: Colors.white,
      tertiary: info,
      onTertiary: Colors.white,
      tertiaryContainer: info.withOpacity(0.7),
      onTertiaryContainer: Colors.white,
      error: danger,
      onError: Colors.white,
      errorContainer: danger.withOpacity(0.7),
      onErrorContainer: Colors.white,
      background: background,
      onBackground: textPrimary,
      surface: surface,
      onSurface: textPrimary,
      surfaceVariant: border,
      onSurfaceVariant: textSecondary,
      outline: border,
      shadow: Colors.black.withOpacity(0.1),
      inverseSurface: darkSurface,
      onInverseSurface: Colors.white,
      inversePrimary: primaryLight,
      surfaceTint: primary.withOpacity(0.05),
    );
  }

  /// Obtient le schéma de couleurs pour le thème sombre
  static ColorScheme getDarkColorScheme() {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: primaryLight,
      onPrimary: Colors.white,
      primaryContainer: primary,
      onPrimaryContainer: Colors.white,
      secondary: secondaryLight,
      onSecondary: Colors.white,
      secondaryContainer: secondary,
      onSecondaryContainer: Colors.white,
      tertiary: info,
      onTertiary: Colors.black,
      tertiaryContainer: info.withOpacity(0.7),
      onTertiaryContainer: Colors.black,
      error: danger,
      onError: Colors.white,
      errorContainer: danger.withOpacity(0.7),
      onErrorContainer: Colors.white,
      background: darkBackground,
      onBackground: Colors.white,
      surface: darkSurface,
      onSurface: Colors.white,
      surfaceVariant: Colors.grey.shade800,
      onSurfaceVariant: Colors.grey.shade300,
      outline: Colors.grey.shade700,
      shadow: Colors.black,
      inverseSurface: surface,
      onInverseSurface: textPrimary,
      inversePrimary: primary,
      surfaceTint: Colors.white.withOpacity(0.05),
    );
  }
}
