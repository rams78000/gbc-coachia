/// Authentication repository interface
abstract class AuthRepository {
  /// Check if user is authenticated
  Future<bool> isAuthenticated();
  
  /// Authenticate user
  Future<void> login(String email, String password);
  
  /// Register new user
  Future<void> register(String email, String password);
  
  /// Logout user
  Future<void> logout();
}
