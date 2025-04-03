import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gbc_coachia/features/auth/presentation/screens/login_screen.dart';
import 'package:gbc_coachia/features/auth/presentation/screens/register_screen.dart';
import 'package:gbc_coachia/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:gbc_coachia/features/chatbot/presentation/screens/chatbot_screen.dart';
import 'package:gbc_coachia/features/finance/presentation/screens/finance_screen.dart';
import 'package:gbc_coachia/features/planner/presentation/screens/planner_screen.dart';
import 'package:gbc_coachia/features/profile/presentation/screens/profile_screen.dart';
import 'package:gbc_coachia/features/onboarding/presentation/screens/onboarding_screen.dart';

/// App router
class AppRouter {
  /// Get router
  static GoRouter getRouter() {
    return GoRouter(
      initialLocation: '/onboarding',
      routes: [
        // Onboarding
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        // Auth
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        // App screens
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/chatbot',
          builder: (context, state) => const ChatbotScreen(),
        ),
        GoRoute(
          path: '/planner',
          builder: (context, state) => const PlannerScreen(),
        ),
        GoRoute(
          path: '/finance',
          builder: (context, state) => const FinanceScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    );
  }
}
