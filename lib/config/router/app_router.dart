import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_state.dart';
import 'package:gbc_coachia/features/auth/presentation/pages/login_page.dart';
import 'package:gbc_coachia/features/auth/presentation/pages/register_page.dart';
import 'package:gbc_coachia/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gbc_coachia/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:gbc_coachia/features/splash/presentation/pages/splash_page.dart';

/// Configurateur du routeur de l'application
class AppRouter {
  /// Instance du BLoC d'authentification
  final AuthBloc _authBloc;
  
  /// Constructeur
  AppRouter({required AuthBloc authBloc}) : _authBloc = authBloc;
  
  /// Créer le routeur de l'application
  GoRouter get router => GoRouter(
    initialLocation: SplashPage.routeName,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(_authBloc.stream),
    redirect: _handleRedirect,
    routes: _routes,
  );
  
  /// Gérer les redirections en fonction de l'état d'authentification
  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final authState = _authBloc.state;
    final isAtSplash = state.matchedLocation == SplashPage.routeName;
    final isAtLogin = state.matchedLocation == LoginPage.routeName;
    final isAtRegister = state.matchedLocation == RegisterPage.routeName;
    final isAtOnboarding = state.matchedLocation == OnboardingPage.routeName;
    
    // Ne pas rediriger sur la page de splash
    if (isAtSplash) {
      return null;
    }
    
    // Si l'onboarding n'a pas été vu, rediriger vers l'onboarding
    final bool hasSeenOnboarding = authState is AuthAuthenticatedState
        ? authState.hasSeenOnboarding
        : authState is AuthUnauthenticatedState
            ? authState.hasSeenOnboarding
            : false;
    
    if (!hasSeenOnboarding && !isAtOnboarding) {
      return OnboardingPage.routeName;
    }
    
    // Si l'utilisateur est authentifié
    if (authState is AuthAuthenticatedState) {
      // Si l'utilisateur est sur la page de connexion ou d'inscription, rediriger vers le tableau de bord
      if (isAtLogin || isAtRegister) {
        return DashboardPage.routeName;
      }
    } 
    // Si l'utilisateur n'est pas authentifié
    else if (authState is AuthUnauthenticatedState) {
      // Si l'utilisateur est sur une page protégée, rediriger vers la connexion
      if (!isAtLogin && !isAtRegister && !isAtOnboarding) {
        return LoginPage.routeName;
      }
    }
    
    // Pas de redirection nécessaire
    return null;
  }
  
  /// Liste des routes de l'application
  List<RouteBase> get _routes => [
    GoRoute(
      path: SplashPage.routeName,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: LoginPage.routeName,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RegisterPage.routeName,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: OnboardingPage.routeName,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: DashboardPage.routeName,
      builder: (context, state) => const DashboardPage(),
    ),
  ];
}

/// Extension pour écouter les changements dans un stream
class GoRouterRefreshStream extends ChangeNotifier {
  /// Stream à écouter
  final Stream<dynamic> _stream;
  
  /// Abonnement au stream
  late final StreamSubscription<dynamic> _subscription;
  
  /// Constructeur
  GoRouterRefreshStream(this._stream) {
    _subscription = _stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    );
  }
  
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
