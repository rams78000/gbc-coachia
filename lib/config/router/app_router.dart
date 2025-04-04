import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/chatbot/presentation/pages/chatbot_page.dart';
import '../../features/planner/presentation/pages/planner_page.dart';
import '../../features/finance/presentation/pages/finance_overview_page.dart';
import '../../features/documents/presentation/pages/documents_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';

class AppRouter {
  final AuthBloc _authBloc;

  AppRouter(this._authBloc);

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    redirect: _handleRedirection,
    routes: _routes,
  );

  // Fonction de redirection intelligente
  String? _handleRedirection(BuildContext context, GoRouterState state) {
    final authState = _authBloc.state;
    final isAuthRouteRequested = state.matchedLocation == '/login' || 
                                state.matchedLocation == '/register' ||
                                state.matchedLocation == '/splash';
    
    // Ne pas rediriger pendant le splash screen
    if (state.matchedLocation == '/splash') {
      return null;
    }
    
    // Vérifier si l'utilisateur est authentifié
    if (authState is AuthSuccess) {
      if (authState.status.isAuthenticated) {
        // L'utilisateur est authentifié
        
        // Si l'utilisateur essaie d'accéder aux pages d'authentification, rediriger vers la page d'accueil
        if (isAuthRouteRequested) {
          return '/';
        }
        
        // Sinon, continuer vers la page demandée
        return null;
      } else {
        // L'utilisateur n'est pas authentifié
        
        // Si l'utilisateur essaie d'accéder aux pages protégées, rediriger vers la page de connexion
        if (!isAuthRouteRequested) {
          return '/login';
        }
        
        // Sinon, continuer vers la page demandée (login ou register)
        return null;
      }
    }
    
    // Par défaut, rediriger vers la page de connexion si l'état d'authentification n'est pas encore déterminé
    // et que l'utilisateur essaie d'accéder à une page protégée
    if (!isAuthRouteRequested) {
      return '/login';
    }
    
    return null;
  }

  // Définition des routes de l'application
  List<RouteBase> get _routes => [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/chatbot',
      builder: (context, state) => const ChatbotPage(),
    ),
    GoRoute(
      path: '/planner',
      builder: (context, state) => const PlannerPage(),
    ),
    GoRoute(
      path: '/finance',
      builder: (context, state) => const FinanceOverviewPage(),
    ),
    GoRoute(
      path: '/documents',
      builder: (context, state) => const DocumentsPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ];
}
