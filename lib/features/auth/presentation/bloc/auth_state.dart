part of 'auth_bloc.dart';

/// États pour le bloc d'authentification
abstract class AuthState extends Equatable {
  /// Constructeur
  const AuthState();
  
  @override
  List<Object> get props => [];
}

/// État initial
class AuthInitial extends AuthState {}

/// État de chargement
class AuthLoading extends AuthState {}

/// État authentifié
class Authenticated extends AuthState {
  /// Constructeur
  const Authenticated({required this.user});

  /// Utilisateur authentifié
  final User user;

  @override
  List<Object> get props => [user];
}

/// État non authentifié
class Unauthenticated extends AuthState {}

/// État d'erreur
class AuthError extends AuthState {
  /// Constructeur
  const AuthError({required this.message});

  /// Message d'erreur
  final String message;

  @override
  List<Object> get props => [message];
}
