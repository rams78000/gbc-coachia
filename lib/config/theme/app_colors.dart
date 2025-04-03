import 'package:flutter/material.dart';

/// App color palette based on the style guide
class AppColors {
  // Light theme colors
  static const Color primary = Color(0xFFB87333);
  static const Color secondary = Color(0xFFFFD700);
  static const Color backgroundLight = Color(0xFFFAFAE6);
  static const Color backgroundDark = Color(0xFFFFFDD0);
  static const Color textPrimary = Color(0xFF2E2E2E);
  static const Color textSecondary = Color(0xFF708090);
  static const Color error = Color(0xFFE53E3E);
  static const Color success = Color(0xFF38A169);
  
  // Dark theme colors
  static const Color darkBackground = Color(0xFF1A202C);
  static const Color darkCard = Color(0xFF2D3748);
  static const Color darkTextPrimary = Color(0xFFEDF2F7);
  
  // Additional UI colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFFE0E0E0);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF757575);
  static const Color transparent = Colors.transparent;
  
  // Status colors
  static const Color warning = Color(0xFFF9A825);
  static const Color info = Color(0xFF2196F3);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFB87333),
      Color(0xFFD4AF37),
    ],
  );
}