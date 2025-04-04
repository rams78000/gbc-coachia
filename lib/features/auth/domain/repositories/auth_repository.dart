/// Interface du repository pour l'authentification
abstract class AuthRepository {
  /// Vérifie si l'utilisateur est connecté
  Future<bool> isAuthenticated();
  
  /// Authentifie l'utilisateur avec email et mot de passe
  Future<void> signInWithEmailAndPassword(String email, String password);
  
  /// Inscrit un nouvel utilisateur
  Future<void> signUpWithEmailAndPassword(String email, String password, String name);
  
  /// Déconnecte l'utilisateur
  Future<void> signOut();
}