import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';

class GBCCoachIAApp extends StatelessWidget {
  const GBCCoachIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GBC CoachIA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // A remplacer par les préférences de l'utilisateur
      routerConfig: appRouter,
    );
  }
}
