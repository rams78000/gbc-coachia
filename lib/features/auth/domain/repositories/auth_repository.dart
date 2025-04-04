/// Interface du repository d'authentification
abstract class AuthRepository {
  /// Connecte un utilisateur
  Future<void> login({required String email, required String password});

  /// Inscrit un nouvel utilisateur
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Déconnecte l'utilisateur
  Future<void> logout();

  /// Vérifie si l'utilisateur est connecté
  Future<bool> isLoggedIn();
}
