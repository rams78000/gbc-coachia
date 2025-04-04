import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gbc_coachia/features/auth/presentation/pages/login_page.dart';
import 'package:gbc_coachia/features/auth/presentation/pages/register_page.dart';
import 'package:gbc_coachia/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gbc_coachia/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:gbc_coachia/features/splash/presentation/pages/splash_page.dart';
import 'package:gbc_coachia/features/documents/presentation/pages/documents_page.dart';

/// Routes de l'application
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String onboarding = '/onboarding';
  static const String dashboard = '/dashboard';
  static const String chatbot = '/chatbot';
  static const String planner = '/planner';
  static const String finance = '/finance';
  static const String profile = '/profile';
  static const String documents = '/documents';
}

/// Configuration du routeur de l'application
class AppRouter {
  static GoRouter router(BuildContext context) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: AppRoutes.documents,
          name: 'documents',
          builder: (context, state) => const DocumentsPage(),
        ),
        // TODO: Ajouter les autres routes au fur et à mesure de l'implémentation
      ],
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state;
        final currentPath = state.uri.path;
        final isLoggingIn = currentPath == AppRoutes.login;
        final isRegistering = currentPath == AppRoutes.register;
        final isOnboarding = currentPath == AppRoutes.onboarding;
        final isSplash = currentPath == AppRoutes.splash;

        // Toujours permettre l'accès à la page de splash et d'onboarding
        if (isSplash || isOnboarding) {
          return null;
        }

        // Vérifier l'état d'authentification
        final bool isLoggedIn = authState is Authenticated;

        // Redirection basée sur l'état d'authentification
        if (isLoggedIn) {
          // Si l'utilisateur est connecté et essaie d'accéder à la page de connexion ou d'inscription,
          // le rediriger vers le tableau de bord
          if (isLoggingIn || isRegistering) {
            return AppRoutes.dashboard;
          }
        } else {
          // Si l'utilisateur n'est pas connecté et essaie d'accéder à une page protégée,
          // le rediriger vers la page de connexion
          if (!isLoggingIn && !isRegistering) {
            return AppRoutes.login;
          }
        }

        // Pas de redirection nécessaire
        return null;
      },
    );
  }
}
