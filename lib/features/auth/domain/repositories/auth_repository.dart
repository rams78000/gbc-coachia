/// Authentication repository interface
abstract class AuthRepository {
  /// Sign in with email and password
  Future<String> signInWithEmailAndPassword(String email, String password);
  
  /// Sign up with email and password
  Future<String> signUpWithEmailAndPassword(String email, String password, String name);
  
  /// Sign out
  Future<void> signOut();
  
  /// Get auth token
  Future<String?> getToken();
  
  /// Get user ID
  Future<String?> getUserId();
  
  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
