import '../../domain/repositories/auth_repository.dart';

/// Implémentation du repository d'authentification
class AuthRepositoryImpl implements AuthRepository {
  // Dans une implémentation réelle, cela aurait des datasources
  // et des services d'authentification (Firebase, etc.)
  
  // Simulation d'état d'authentification
  bool _isLoggedIn = false;
  
  @override
  Future<bool> isAuthenticated() async {
    // Pour l'instant, on retourne toujours true pour le développement
    return true;
  }
  
  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // Simulation d'authentification réussie
    _isLoggedIn = true;
  }
  
  @override
  Future<void> signUpWithEmailAndPassword(String email, String password, String name) async {
    // Simulation d'inscription réussie
    _isLoggedIn = true;
  }
  
  @override
  Future<void> signOut() async {
    // Simulation de déconnexion
    _isLoggedIn = false;
  }
}