import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/chatbot/presentation/screens/chatbot_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/finance/presentation/screens/finance_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/planner/presentation/screens/planner_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

/// Classe pour gérer le routage de l'application
class AppRouter {
  /// Crée le routeur de l'application
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/onboarding',
      routes: [
        // Route d'onboarding
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        
        // Routes d'authentification
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupScreen(),
        ),
        
        // Route du tableau de bord (page principale)
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardScreen(),
        ),
        
        // Route du chatbot
        GoRoute(
          path: '/chatbot',
          builder: (context, state) => const ChatbotScreen(),
        ),
        
        // Route du planificateur
        GoRoute(
          path: '/planner',
          builder: (context, state) => const PlannerScreen(),
        ),
        
        // Route des finances
        GoRoute(
          path: '/finance',
          builder: (context, state) => const FinanceScreen(),
        ),
        
        // Route du profil
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Route non trouvée : ${state.error}'),
        ),
      ),
    );
  }
}
