import 'package:gbc_coachia/features/auth/domain/entities/user.dart';

/// Interface du repository d'authentification
abstract class AuthRepository {
  /// Vérifie si l'utilisateur est connecté
  Future<bool> isLoggedIn();

  /// Connecte un utilisateur
  Future<User> login({
    required String email,
    required String password,
  });

  /// Inscrit un nouvel utilisateur
  Future<User> register({
    required String email,
    required String password,
    String? nom,
    String? prenom,
  });

  /// Récupère l'utilisateur courant
  Future<User?> getCurrentUser();

  /// Déconnecte l'utilisateur
  Future<void> logout();

  /// Réinitialise le mot de passe d'un utilisateur
  Future<void> resetPassword({required String email});
}
