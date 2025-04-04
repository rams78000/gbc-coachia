import 'package:flutter/material.dart';
import 'config/router/app_router.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GBC CoachIA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFB87333),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB87333),
          primary: const Color(0xFFB87333),
          secondary: const Color(0xFFFFD700),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB87333),
          foregroundColor: Colors.white,
        ),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFB87333),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB87333),
          primary: const Color(0xFFB87333),
          secondary: const Color(0xFFFFD700),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB87333),
          foregroundColor: Colors.white,
        ),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
