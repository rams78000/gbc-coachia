import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/domain/entities/auth_status.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    routes: [
      // Page de démarrage
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      
      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // Authentification
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Interface principale
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
    
    // Redirection basée sur l'état d'authentification et d'onboarding
    redirect: (BuildContext context, GoRouterState state) {
      // Récupérer les états des BLoCs
      final authState = context.read<AuthBloc>().state;
      final onboardingState = context.read<OnboardingBloc>().state;
      
      // L'utilisateur est sur la page de splash, ne pas rediriger
      if (state.path == '/') {
        return null;
      }

      // Vérifier si l'onboarding a été complété
      if (onboardingState is OnboardingNotCompleted && state.path != '/onboarding') {
        return '/onboarding';
      }
      
      // Vérifier l'état d'authentification
      if (authState is AuthSuccess) {
        final authStatus = authState.status;
        
        if (authStatus.isAuthenticated) {
          // L'utilisateur est authentifié mais n'est pas sur une page protégée
          if (state.path == '/login' || state.path == '/register' || state.path == '/onboarding') {
            return '/dashboard';
          }
        } else if (authStatus.isUnauthenticated) {
          // L'utilisateur n'est pas authentifié mais essaie d'accéder à une page protégée
          if (state.path == '/dashboard') {
            return '/login';
          }
        }
      }
      
      // Aucune redirection nécessaire
      return null;
    },
    
    // Configuration par défaut
    initialLocation: '/',
    debugLogDiagnostics: true,
  );
}
