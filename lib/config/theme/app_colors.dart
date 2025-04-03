import 'package:flutter/material.dart';

/// App color palette
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2C3E50);
  static const Color primaryLight = Color(0xFF34495E);
  static const Color primaryDark = Color(0xFF1A2530);
  
  // Accent Colors
  static const Color accent = Color(0xFF3498DB);
  static const Color accentLight = Color(0xFF5DADE2);
  static const Color accentDark = Color(0xFF2980B9);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF27AE60);
  static const Color secondaryLight = Color(0xFF2ECC71);
  static const Color secondaryDark = Color(0xFF219653);
  
  // Neutrals
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color divider = Color(0xFFBDC3C7);
  
  // Dark Mode
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFECF0F1);
  static const Color darkTextSecondary = Color(0xFFBDC3C7);
  static const Color darkDivider = Color(0xFF2C3E50);
  
  // Status Colors
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
