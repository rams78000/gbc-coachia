import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gbc_coachia/features/auth/presentation/screens/login_screen.dart';
import 'package:gbc_coachia/features/auth/presentation/screens/signup_screen.dart';
import 'package:gbc_coachia/features/chatbot/presentation/screens/chatbot_screen.dart';
import 'package:gbc_coachia/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:gbc_coachia/features/finance/presentation/screens/finance_screen.dart';
import 'package:gbc_coachia/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:gbc_coachia/features/planner/presentation/screens/planner_screen.dart';
import 'package:gbc_coachia/features/profile/presentation/screens/profile_screen.dart';

/// App router using go_router
class AppRouter {
  /// Router instance
  static final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/chatbot',
        name: 'chatbot',
        builder: (context, state) => const ChatbotScreen(),
      ),
      GoRoute(
        path: '/planner',
        name: 'planner',
        builder: (context, state) => const PlannerScreen(),
      ),
      GoRoute(
        path: '/finance',
        name: 'finance',
        builder: (context, state) => const FinanceScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}