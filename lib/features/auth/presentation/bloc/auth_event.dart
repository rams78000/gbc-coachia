part of 'auth_bloc.dart';

/// Événements pour le bloc d'authentification
abstract class AuthEvent extends Equatable {
  /// Constructeur
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Événement pour vérifier le statut d'authentification
class CheckAuthStatus extends AuthEvent {}

/// Événement pour la connexion
class LoginRequested extends AuthEvent {
  /// Constructeur
  const LoginRequested({
    required this.email,
    required this.password,
  });

  /// Email
  final String email;
  
  /// Mot de passe
  final String password;

  @override
  List<Object> get props => [email, password];
}

/// Événement pour l'inscription
class RegisterRequested extends AuthEvent {
  /// Constructeur
  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  /// Nom
  final String name;
  
  /// Email
  final String email;
  
  /// Mot de passe
  final String password;

  @override
  List<Object> get props => [name, email, password];
}

/// Événement pour la déconnexion
class LogoutRequested extends AuthEvent {}
