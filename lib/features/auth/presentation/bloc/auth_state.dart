import 'package:gbc_coachia/features/auth/domain/entities/user.dart';

/// État d'authentification
abstract class AuthState {
  /// Constructeur par défaut
  const AuthState();
}

/// État initial
class AuthInitialState extends AuthState {
  /// Constructeur
  const AuthInitialState();
}

/// État de chargement
class AuthLoadingState extends AuthState {
  /// Constructeur
  const AuthLoadingState();
}

/// État authentifié
class AuthAuthenticatedState extends AuthState {
  /// Utilisateur connecté
  final User user;
  
  /// Indique si l'utilisateur a déjà vu l'onboarding
  final bool hasSeenOnboarding;
  
  /// Constructeur
  const AuthAuthenticatedState({
    required this.user,
    this.hasSeenOnboarding = false,
  });
  
  /// Créer une copie de l'état avec des modifications
  AuthAuthenticatedState copyWith({
    User? user,
    bool? hasSeenOnboarding,
  }) {
    return AuthAuthenticatedState(
      user: user ?? this.user,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
    );
  }
}

/// État non authentifié
class AuthUnauthenticatedState extends AuthState {
  /// Indique si l'utilisateur a déjà vu l'onboarding
  final bool hasSeenOnboarding;
  
  /// Constructeur
  const AuthUnauthenticatedState({
    this.hasSeenOnboarding = false,
  });
  
  /// Créer une copie de l'état avec des modifications
  AuthUnauthenticatedState copyWith({
    bool? hasSeenOnboarding,
  }) {
    return AuthUnauthenticatedState(
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
    );
  }
}

/// État d'erreur
class AuthErrorState extends AuthState {
  /// Message d'erreur
  final String message;
  
  /// Code d'erreur
  final String? code;
  
  /// Constructeur
  const AuthErrorState({
    required this.message,
    this.code,
  });
}
