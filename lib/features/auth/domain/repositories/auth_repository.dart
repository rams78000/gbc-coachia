import '../entities/user.dart';

/// Interface pour le repository d'authentification
abstract class AuthRepository {
  /// Vérifie si l'utilisateur est connecté
  Future<bool> isLoggedIn();

  /// Récupère l'utilisateur actuellement connecté
  Future<User?> getCurrentUser();

  /// Connecte un utilisateur avec email et mot de passe
  Future<User> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Inscrit un nouvel utilisateur avec email et mot de passe
  Future<User> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  /// Déconnecte l'utilisateur
  Future<void> logout();
}
