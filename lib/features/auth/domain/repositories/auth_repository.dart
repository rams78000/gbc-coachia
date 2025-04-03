/// Interface for the Auth Repository
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Map<String, dynamic>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  /// Sign up with email and password
  Future<Map<String, dynamic>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });
  
  /// Sign out
  Future<void> signOut();
  
  /// Get current user
  Future<Map<String, dynamic>?> getCurrentUser();
  
  /// Reset password
  Future<void> resetPassword({required String email});
  
  /// Update user profile
  Future<bool> updateUserProfile({required Map<String, dynamic> userData});
  
  /// Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  
  /// Check if user is signed in
  Future<bool> isSignedIn();
}
