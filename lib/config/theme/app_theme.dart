import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Définition des couleurs et du thème pour l'application
class AppTheme {
  // Couleurs principales de l'application
  static const Color primaryColor = Color(0xFFB87333); // Copper/bronze
  static const Color secondaryColor = Color(0xFFFFD700); // Gold
  static const Color accentColor = Color(0xFF8B7355); // Copper shadow
  
  // Couleurs pour le light mode
  static const Color lightBackground = Color(0xFFF8F8F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF202020);
  static const Color lightTextSecondary = Color(0xFF757575);
  
  // Couleurs pour le dark mode
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkText = Color(0xFFF1F1F1);
  static const Color darkTextSecondary = Color(0xFFBBBBBB);
  
  /// Génère le thème light
  static ThemeData lightTheme() {
    return _baseTheme(
      brightness: Brightness.light,
      background: lightBackground,
      surface: lightSurface,
      text: lightText,
      textSecondary: lightTextSecondary,
    );
  }
  
  /// Génère le thème dark
  static ThemeData darkTheme() {
    return _baseTheme(
      brightness: Brightness.dark,
      background: darkBackground,
      surface: darkSurface,
      text: darkText,
      textSecondary: darkTextSecondary,
    );
  }
  
  /// Configuration commune aux deux thèmes
  static ThemeData _baseTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color text,
    required Color textSecondary,
  }) {
    return ThemeData(
      // Utilisation de la police Inter (via Google Fonts)
      textTheme: GoogleFonts.interTextTheme(
        brightness == Brightness.light
            ? ThemeData.light().textTheme
            : ThemeData.dark().textTheme,
      ),
      
      // Couleurs principales
      primaryColor: primaryColor,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        background: background,
        onBackground: text,
        surface: surface,
        onSurface: text,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: background,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      // Boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // TextField
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: brightness == Brightness.light
                ? Colors.grey[300]!
                : Colors.grey[700]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: brightness == Brightness.light
                ? Colors.grey[300]!
                : Colors.grey[700]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        filled: true,
        fillColor: brightness == Brightness.light
            ? Colors.grey[50]
            : Colors.grey[800],
      ),
      
      // Cards
      cardTheme: CardTheme(
        color: surface,
        elevation: 2,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      
      // Navigation bar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primaryColor.withOpacity(0.2),
        labelTextStyle: MaterialStateProperty.all(
          GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: text,
          ),
        ),
        iconTheme: MaterialStateProperty.all(
          IconThemeData(
            color: textSecondary,
            size: 24,
          ),
        ),
      ),
      
      // Drawer
      drawerTheme: DrawerThemeData(
        backgroundColor: surface,
        scrimColor: Colors.black54,
      ),
      
      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: brightness == Brightness.light
            ? Colors.grey[100]!
            : Colors.grey[800]!,
        disabledColor: brightness == Brightness.light
            ? Colors.grey[200]!
            : Colors.grey[700]!,
        selectedColor: primaryColor.withOpacity(0.2),
        secondarySelectedColor: secondaryColor.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: text,
        ),
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: brightness == Brightness.light
            ? Colors.grey[300]
            : Colors.grey[700],
        thickness: 1,
        space: 1,
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}