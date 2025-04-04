import 'package:flutter/material.dart';

/// Classe pour la gestion du thème de l'application
class AppTheme {
  /// Obtenir le thème principal
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      inputDecorationTheme: _inputDecorationTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      textTheme: _textTheme,
      snackBarTheme: _snackBarTheme,
      dialogTheme: _dialogTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
      dividerTheme: _dividerTheme,
      tabBarTheme: _tabBarTheme,
      switchTheme: _switchTheme,
      checkboxTheme: _checkboxTheme,
      radioTheme: _radioTheme,
      sliderTheme: _sliderTheme,
      chipTheme: _chipTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme,
    );
  }
  
  /// Obtenir le thème sombre
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      appBarTheme: _darkAppBarTheme,
      cardTheme: _darkCardTheme,
      inputDecorationTheme: _darkInputDecorationTheme,
      elevatedButtonTheme: _darkElevatedButtonTheme,
      outlinedButtonTheme: _darkOutlinedButtonTheme,
      textButtonTheme: _darkTextButtonTheme,
      textTheme: _darkTextTheme,
      snackBarTheme: _darkSnackBarTheme,
      dialogTheme: _darkDialogTheme,
      bottomNavigationBarTheme: _darkBottomNavigationBarTheme,
      dividerTheme: _darkDividerTheme,
      tabBarTheme: _darkTabBarTheme,
      switchTheme: _darkSwitchTheme,
      checkboxTheme: _darkCheckboxTheme,
      radioTheme: _darkRadioTheme,
      sliderTheme: _darkSliderTheme,
      chipTheme: _darkChipTheme,
      floatingActionButtonTheme: _darkFloatingActionButtonTheme,
    );
  }
  
  // Schéma de couleurs pour le thème clair
  static final _lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF006064), // Couleur primaire Cyan
    primary: const Color(0xFF006064),
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFF82FBFF),
    onPrimaryContainer: const Color(0xFF001F21),
    secondary: const Color(0xFF4A6365),
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFCDE8EA),
    onSecondaryContainer: const Color(0xFF051F21),
    tertiary: const Color(0xFF50606D),
    onTertiary: Colors.white,
    tertiaryContainer: const Color(0xFFD3E5F6),
    onTertiaryContainer: const Color(0xFF0C1D29),
    error: const Color(0xFFBA1A1A),
    onError: Colors.white,
    errorContainer: const Color(0xFFFFDAD6),
    onErrorContainer: const Color(0xFF410002),
    background: const Color(0xFFFAFDFD),
    onBackground: const Color(0xFF191C1D),
    surface: const Color(0xFFFAFDFD),
    onSurface: const Color(0xFF191C1D),
    surfaceVariant: const Color(0xFFDAE4E5),
    onSurfaceVariant: const Color(0xFF3F484A),
    outline: const Color(0xFF6F797B),
    outlineVariant: const Color(0xFFBEC8C9),
    shadow: const Color(0xFF000000),
    scrim: const Color(0xFF000000),
    inverseSurface: const Color(0xFF2E3132),
    onInverseSurface: const Color(0xFFEFF1F1),
    inversePrimary: const Color(0xFF4CDCE1),
    surfaceTint: const Color(0xFF006064),
  );
  
  // Schéma de couleurs pour le thème sombre
  static final _darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF006064),
    brightness: Brightness.dark,
    primary: const Color(0xFF4CDCE1),
    onPrimary: const Color(0xFF003739),
    primaryContainer: const Color(0xFF004F52),
    onPrimaryContainer: const Color(0xFF82FBFF),
    secondary: const Color(0xFFB1CCCF),
    onSecondary: const Color(0xFF1A3436),
    secondaryContainer: const Color(0xFF324B4D),
    onSecondaryContainer: const Color(0xFFCDE8EA),
    tertiary: const Color(0xFFB7C9DA),
    onTertiary: const Color(0xFF21323E),
    tertiaryContainer: const Color(0xFF384956),
    onTertiaryContainer: const Color(0xFFD3E5F6),
    error: const Color(0xFFFFB4AB),
    onError: const Color(0xFF690005),
    errorContainer: const Color(0xFF93000A),
    onErrorContainer: const Color(0xFFFFB4AB),
    background: const Color(0xFF191C1D),
    onBackground: const Color(0xFFE1E3E3),
    surface: const Color(0xFF191C1D),
    onSurface: const Color(0xFFE1E3E3),
    surfaceVariant: const Color(0xFF3F484A),
    onSurfaceVariant: const Color(0xFFBEC8C9),
    outline: const Color(0xFF899294),
    outlineVariant: const Color(0xFF3F484A),
    shadow: const Color(0xFF000000),
    scrim: const Color(0xFF000000),
    inverseSurface: const Color(0xFFE1E3E3),
    onInverseSurface: const Color(0xFF2E3132),
    inversePrimary: const Color(0xFF006064),
    surfaceTint: const Color(0xFF4CDCE1),
  );
  
  // Thème pour les barres d'application
  static final _appBarTheme = AppBarTheme(
    backgroundColor: _lightColorScheme.surface,
    foregroundColor: _lightColorScheme.onSurface,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: _lightColorScheme.onSurface,
    ),
  );
  
  // Thème pour les cartes
  static final _cardTheme = CardTheme(
    color: _lightColorScheme.surface,
    elevation: 1,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );
  
  // Thème pour les champs de texte
  static final _inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: _lightColorScheme.surfaceVariant.withOpacity(0.3),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: _lightColorScheme.primary,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: _lightColorScheme.error,
        width: 2,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: _lightColorScheme.error,
        width: 2,
      ),
    ),
    errorStyle: TextStyle(
      color: _lightColorScheme.error,
      fontSize: 12,
    ),
    labelStyle: TextStyle(
      color: _lightColorScheme.onSurfaceVariant,
      fontSize: 16,
    ),
    hintStyle: TextStyle(
      color: _lightColorScheme.onSurfaceVariant.withOpacity(0.7),
      fontSize: 16,
    ),
    helperStyle: TextStyle(
      color: _lightColorScheme.onSurfaceVariant.withOpacity(0.7),
      fontSize: 12,
    ),
    prefixIconColor: _lightColorScheme.onSurfaceVariant,
    suffixIconColor: _lightColorScheme.onSurfaceVariant,
  );
  
  // Thème pour les boutons élevés
  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _lightColorScheme.primary,
      foregroundColor: _lightColorScheme.onPrimary,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    ),
  );
  
  // Thème pour les boutons avec contour
  static final _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: _lightColorScheme.primary,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: BorderSide(
        color: _lightColorScheme.outline,
        width: 1,
      ),
    ),
  );
  
  // Thème pour les boutons texte
  static final _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _lightColorScheme.primary,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
  
  // Thème pour les textes
  static final _textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: _lightColorScheme.onSurface,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w500,
      color: _lightColorScheme.onSurface,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: _lightColorScheme.onSurface,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: _lightColorScheme.onSurface,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: _lightColorScheme.onSurface,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: _lightColorScheme.onSurface,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: _lightColorScheme.onSurface,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: _lightColorScheme.onSurface,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: _lightColorScheme.onSurface,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: _lightColorScheme.onSurface,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: _lightColorScheme.onSurface,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: _lightColorScheme.onSurface,
    ),
  );
  
  // Thème pour les snackbars
  static final _snackBarTheme = SnackBarThemeData(
    backgroundColor: _lightColorScheme.inverseSurface,
    contentTextStyle: TextStyle(
      color: _lightColorScheme.onInverseSurface,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    behavior: SnackBarBehavior.floating,
  );
  
  // Thème pour les dialogues
  static final _dialogTheme = DialogTheme(
    backgroundColor: _lightColorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: _lightColorScheme.onSurface,
    ),
    contentTextStyle: TextStyle(
      fontSize: 16,
      color: _lightColorScheme.onSurface,
    ),
  );
  
  // Thème pour la barre de navigation du bas
  static final _bottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: _lightColorScheme.surface,
    selectedItemColor: _lightColorScheme.primary,
    unselectedItemColor: _lightColorScheme.onSurfaceVariant,
    selectedLabelStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  );
  
  // Thème pour les séparateurs
  static final _dividerTheme = DividerThemeData(
    space: 1,
    thickness: 1,
    color: _lightColorScheme.outlineVariant,
  );
  
  // Thème pour les onglets
  static final _tabBarTheme = TabBarTheme(
    labelColor: _lightColorScheme.primary,
    unselectedLabelColor: _lightColorScheme.onSurfaceVariant,
    indicatorColor: _lightColorScheme.primary,
    labelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  );
  
  // Thème pour les interrupteurs
  static final _switchTheme = SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return _lightColorScheme.primary;
      }
      return _lightColorScheme.outline;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return _lightColorScheme.primaryContainer;
      }
      return _lightColorScheme.surfaceVariant;
    }),
  );
  
  // Thème pour les cases à cocher
  static final _checkboxTheme = CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return _lightColorScheme.primary;
      }
      return Colors.transparent;
    }),
    checkColor: MaterialStateProperty.resolveWith((states) {
      return _lightColorScheme.onPrimary;
    }),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    side: BorderSide(
      color: _lightColorScheme.outline,
      width: 2,
    ),
  );
  
  // Thème pour les boutons radio
  static final _radioTheme = RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return _lightColorScheme.primary;
      }
      return _lightColorScheme.outline;
    }),
  );
  
  // Thème pour les sliders
  static final _sliderTheme = SliderThemeData(
    activeTrackColor: _lightColorScheme.primary,
    inactiveTrackColor: _lightColorScheme.surfaceVariant,
    thumbColor: _lightColorScheme.primary,
    overlayColor: _lightColorScheme.primary.withOpacity(0.12),
    trackHeight: 4,
    thumbShape: const RoundSliderThumbShape(
      enabledThumbRadius: 10,
    ),
    overlayShape: const RoundSliderOverlayShape(
      overlayRadius: 20,
    ),
  );
  
  // Thème pour les chips
  static final _chipTheme = ChipThemeData(
    backgroundColor: _lightColorScheme.surfaceVariant,
    labelStyle: TextStyle(
      color: _lightColorScheme.onSurfaceVariant,
      fontSize: 14,
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    side: BorderSide.none,
    selectedColor: _lightColorScheme.primaryContainer,
    selectedShadowColor: Colors.transparent,
    checkmarkColor: _lightColorScheme.primary,
    deleteIconColor: _lightColorScheme.onSurfaceVariant,
  );
  
  // Thème pour les boutons flottants
  static final _floatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: _lightColorScheme.primary,
    foregroundColor: _lightColorScheme.onPrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 4,
    focusElevation: 8,
    hoverElevation: 6,
    highlightElevation: 10,
  );
  
  // Versions sombres des thèmes
  
  static final _darkAppBarTheme = _appBarTheme.copyWith(
    backgroundColor: _darkColorScheme.surface,
    foregroundColor: _darkColorScheme.onSurface,
    titleTextStyle: _appBarTheme.titleTextStyle?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
  );
  
  static final _darkCardTheme = _cardTheme.copyWith(
    color: _darkColorScheme.surface,
  );
  
  static final _darkInputDecorationTheme = _inputDecorationTheme.copyWith(
    fillColor: _darkColorScheme.surfaceVariant.withOpacity(0.3),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: _darkColorScheme.primary,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: _darkColorScheme.error,
        width: 2,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: _darkColorScheme.error,
        width: 2,
      ),
    ),
    errorStyle: TextStyle(
      color: _darkColorScheme.error,
      fontSize: 12,
    ),
    labelStyle: TextStyle(
      color: _darkColorScheme.onSurfaceVariant,
      fontSize: 16,
    ),
    hintStyle: TextStyle(
      color: _darkColorScheme.onSurfaceVariant.withOpacity(0.7),
      fontSize: 16,
    ),
    helperStyle: TextStyle(
      color: _darkColorScheme.onSurfaceVariant.withOpacity(0.7),
      fontSize: 12,
    ),
    prefixIconColor: _darkColorScheme.onSurfaceVariant,
    suffixIconColor: _darkColorScheme.onSurfaceVariant,
  );
  
  static final _darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _darkColorScheme.primary,
      foregroundColor: _darkColorScheme.onPrimary,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    ),
  );
  
  static final _darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: _darkColorScheme.primary,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: BorderSide(
        color: _darkColorScheme.outline,
        width: 1,
      ),
    ),
  );
  
  static final _darkTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _darkColorScheme.primary,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
  
  static final _darkTextTheme = _textTheme.copyWith(
    headlineLarge: _textTheme.headlineLarge?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
    headlineMedium: _textTheme.headlineMedium?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
    headlineSmall: _textTheme.headlineSmall?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
    titleLarge: _textTheme.titleLarge?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
    titleMedium: _textTheme.titleMedium?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
    titleSmall: _textTheme.titleSmall?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
    bodyLarge: _textTheme.bodyLarge?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
    bodyMedium: _textTheme.bodyMedium?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
    bodySmall: _textTheme.bodySmall?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
    labelLarge: _textTheme.labelLarge?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
    labelMedium: _textTheme.labelMedium?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
    labelSmall: _textTheme.labelSmall?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
  );
  
  static final _darkSnackBarTheme = _snackBarTheme.copyWith(
    backgroundColor: _darkColorScheme.inverseSurface,
    contentTextStyle: TextStyle(
      color: _darkColorScheme.onInverseSurface,
    ),
  );
  
  static final _darkDialogTheme = _dialogTheme.copyWith(
    backgroundColor: _darkColorScheme.surface,
    titleTextStyle: _dialogTheme.titleTextStyle?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
    contentTextStyle: _dialogTheme.contentTextStyle?.copyWith(
      color: _darkColorScheme.onSurface,
    ),
  );
  
  static final _darkBottomNavigationBarTheme = _bottomNavigationBarTheme.copyWith(
    backgroundColor: _darkColorScheme.surface,
    selectedItemColor: _darkColorScheme.primary,
    unselectedItemColor: _darkColorScheme.onSurfaceVariant,
  );
  
  static final _darkDividerTheme = _dividerTheme.copyWith(
    color: _darkColorScheme.outlineVariant,
  );
  
  static final _darkTabBarTheme = _tabBarTheme.copyWith(
    labelColor: _darkColorScheme.primary,
    unselectedLabelColor: _darkColorScheme.onSurfaceVariant,
    indicatorColor: _darkColorScheme.primary,
  );
  
  static final _darkSwitchTheme = SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return _darkColorScheme.primary;
      }
      return _darkColorScheme.outline;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return _darkColorScheme.primaryContainer;
      }
      return _darkColorScheme.surfaceVariant;
    }),
  );
  
  static final _darkCheckboxTheme = CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return _darkColorScheme.primary;
      }
      return Colors.transparent;
    }),
    checkColor: MaterialStateProperty.resolveWith((states) {
      return _darkColorScheme.onPrimary;
    }),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    side: BorderSide(
      color: _darkColorScheme.outline,
      width: 2,
    ),
  );
  
  static final _darkRadioTheme = RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return _darkColorScheme.primary;
      }
      return _darkColorScheme.outline;
    }),
  );
  
  static final _darkSliderTheme = _sliderTheme.copyWith(
    activeTrackColor: _darkColorScheme.primary,
    inactiveTrackColor: _darkColorScheme.surfaceVariant,
    thumbColor: _darkColorScheme.primary,
    overlayColor: _darkColorScheme.primary.withOpacity(0.12),
  );
  
  static final _darkChipTheme = _chipTheme.copyWith(
    backgroundColor: _darkColorScheme.surfaceVariant,
    labelStyle: _chipTheme.labelStyle?.copyWith(
      color: _darkColorScheme.onSurfaceVariant,
    ),
    selectedColor: _darkColorScheme.primaryContainer,
    checkmarkColor: _darkColorScheme.primary,
    deleteIconColor: _darkColorScheme.onSurfaceVariant,
  );
  
  static final _darkFloatingActionButtonTheme = _floatingActionButtonTheme.copyWith(
    backgroundColor: _darkColorScheme.primary,
    foregroundColor: _darkColorScheme.onPrimary,
  );
}
