part of 'auth_bloc.dart';

/// Événements d'authentification
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Vérifier le statut d'authentification
class CheckAuthStatus extends AuthEvent {}

/// Connexion utilisateur
class LoginUser extends AuthEvent {
  final String email;
  final String password;

  const LoginUser({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Inscription utilisateur
class RegisterUser extends AuthEvent {
  final String email;
  final String password;
  final String nom;
  final String? prenom;

  const RegisterUser({
    required this.email,
    required this.password,
    required this.nom,
    this.prenom,
  });

  @override
  List<Object?> get props => [email, password, nom, prenom];
}

/// Déconnexion utilisateur
class LogoutUser extends AuthEvent {}

/// Réinitialisation du mot de passe
class ResetPassword extends AuthEvent {
  final String email;

  const ResetPassword({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Mise à jour du profil utilisateur
class UpdateUserProfile extends AuthEvent {
  final User user;

  const UpdateUserProfile({required this.user});

  @override
  List<Object?> get props => [user];
}
