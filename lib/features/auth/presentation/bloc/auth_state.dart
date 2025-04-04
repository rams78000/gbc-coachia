part of 'auth_bloc.dart';

/// États d'authentification
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// État initial
class AuthInitial extends AuthState {}

/// Chargement en cours
class AuthLoading extends AuthState {}

/// Utilisateur authentifié
class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Utilisateur non authentifié
class Unauthenticated extends AuthState {}

/// Erreur d'authentification
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Réinitialisation de mot de passe réussie
class ResetPasswordSuccess extends AuthState {
  final String message;

  const ResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
