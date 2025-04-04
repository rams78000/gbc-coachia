import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';
import 'package:gbc_coachia/core/utils/screenshot_generator.dart';
import 'package:gbc_coachia/features/auth/presentation/pages/login_page.dart';
import 'package:gbc_coachia/features/auth/presentation/pages/register_page.dart';
import 'package:gbc_coachia/features/chatbot/presentation/pages/chatbot_page.dart';
import 'package:gbc_coachia/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gbc_coachia/features/finance/presentation/pages/finance_overview_page.dart';
import 'package:gbc_coachia/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:gbc_coachia/features/planner/presentation/pages/planner_page.dart';
import 'package:gbc_coachia/features/profile/presentation/pages/profile_page.dart';
import 'package:gbc_coachia/features/splash/presentation/pages/splash_page.dart';

/// Utilitaire pour générer des prévisualisations des écrans de l'application
class AppPreviewer {
  /// Génère des prévisualisations pour tous les écrans principaux
  static Future<void> generateAllPreviews() async {
    final screens = [
      {'widget': const SplashPage(), 'name': 'splash_screen'},
      {'widget': const OnboardingPage(), 'name': 'onboarding_screen'},
      {'widget': const LoginPage(), 'name': 'login_screen'},
      {'widget': const RegisterPage(), 'name': 'register_screen'},
      {'widget': const DashboardPage(), 'name': 'dashboard_screen'},
      {'widget': const ChatbotPage(), 'name': 'chatbot_screen'},
      {'widget': const PlannerPage(), 'name': 'planner_screen'},
      {'widget': const FinanceOverviewPage(), 'name': 'finance_screen'},
      {'widget': const ProfilePage(), 'name': 'profile_screen'},
    ];

    // Générer les captures d'écran en mode clair
    await _generatePreviewsWithTheme(
      screens: screens,
      themeMode: ThemeMode.light,
      suffix: '_light',
    );

    // Générer les captures d'écran en mode sombre
    await _generatePreviewsWithTheme(
      screens: screens,
      themeMode: ThemeMode.dark,
      suffix: '_dark',
    );
    
    // Créer un fichier HTML pour afficher les captures d'écran
    await _generateHtmlPreview(screens);
    
    print('Toutes les prévisualisations ont été générées!');
    print('Ouvrez preview/index.html pour voir les résultats');
  }
  
  /// Génère les prévisualisations avec un thème spécifique
  static Future<void> _generatePreviewsWithTheme({
    required List<Map<String, dynamic>> screens,
    required ThemeMode themeMode,
    required String suffix,
  }) async {
    for (final screen in screens) {
      final Widget widget = screen['widget'] as Widget;
      final String name = '${screen['name']}$suffix';
      
      // Emballer le widget dans l'application pour appliquer le thème
      final wrappedWidget = GBCCoachIAApp(
        initialWidget: widget,
        initialThemeMode: themeMode,
      );
      
      await ScreenshotGenerator.captureWidget(
        widget: wrappedWidget,
        fileName: name,
      );
      
      print('Prévisualisation générée: $name');
    }
  }
  
  /// Génère un fichier HTML pour afficher les prévisualisations
  static Future<void> _generateHtmlPreview(List<Map<String, dynamic>> screens) async {
    final StringBuffer html = StringBuffer();
    
    html.writeln('<!DOCTYPE html>');
    html.writeln('<html lang="fr">');
    html.writeln('<head>');
    html.writeln('  <meta charset="UTF-8">');
    html.writeln('  <meta name="viewport" content="width=device-width, initial-scale=1.0">');
    html.writeln('  <title>GBC CoachIA - Prévisualisations</title>');
    html.writeln('  <style>');
    html.writeln('    body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }');
    html.writeln('    h1 { text-align: center; color: #333; }');
    html.writeln('    .container { display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; }');
    html.writeln('    .preview-card { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }');
    html.writeln('    .preview-row { display: flex; }');
    html.writeln('    .preview-item { padding: 10px; text-align: center; }');
    html.writeln('    .preview-item img { max-height: 600px; border: 1px solid #ddd; border-radius: 10px; }');
    html.writeln('    .preview-item h3 { margin: 10px 0; color: #555; }');
    html.writeln('    .theme-title { text-align: center; margin: 20px 0; padding-top: 20px; border-top: 1px solid #ddd; }');
    html.writeln('  </style>');
    html.writeln('</head>');
    html.writeln('<body>');
    html.writeln('  <h1>GBC CoachIA - Prévisualisations Mobile</h1>');
    
    // Section Mode Clair
    html.writeln('  <h2 class="theme-title">Mode Clair</h2>');
    html.writeln('  <div class="container">');
    
    for (final screen in screens) {
      final String name = '${screen['name']}_light';
      final String title = _formatScreenName(screen['name'] as String);
      
      html.writeln('    <div class="preview-card">');
      html.writeln('      <div class="preview-item">');
      html.writeln('        <img src="screenshots/$name.png" alt="$title" />');
      html.writeln('        <h3>$title</h3>');
      html.writeln('      </div>');
      html.writeln('    </div>');
    }
    
    html.writeln('  </div>');
    
    // Section Mode Sombre
    html.writeln('  <h2 class="theme-title">Mode Sombre</h2>');
    html.writeln('  <div class="container">');
    
    for (final screen in screens) {
      final String name = '${screen['name']}_dark';
      final String title = _formatScreenName(screen['name'] as String);
      
      html.writeln('    <div class="preview-card">');
      html.writeln('      <div class="preview-item">');
      html.writeln('        <img src="screenshots/$name.png" alt="$title" />');
      html.writeln('        <h3>$title</h3>');
      html.writeln('      </div>');
      html.writeln('    </div>');
    }
    
    html.writeln('  </div>');
    html.writeln('</body>');
    html.writeln('</html>');
    
    // Écrire le fichier HTML
    final File file = File('/home/runner/workspace/preview/index.html');
    await file.writeAsString(html.toString());
  }
  
  /// Formate le nom de l'écran pour l'affichage
  static String _formatScreenName(String name) {
    final String withoutScreen = name.replaceAll('_screen', '');
    final List<String> words = withoutScreen.split('_');
    final List<String> capitalized = words.map((word) => 
      '${word[0].toUpperCase()}${word.substring(1)}'
    ).toList();
    
    return capitalized.join(' ');
  }
}

/// Widget pour initialiser l'application avec un widget spécifique
class GBCCoachIAApp extends StatelessWidget {
  final Widget initialWidget;
  final ThemeMode initialThemeMode;
  
  const GBCCoachIAApp({
    super.key,
    required this.initialWidget,
    this.initialThemeMode = ThemeMode.light,
  });
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GBC CoachIA',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: initialThemeMode,
      home: initialWidget,
      debugShowCheckedModeBanner: false,
    );
  }
}
