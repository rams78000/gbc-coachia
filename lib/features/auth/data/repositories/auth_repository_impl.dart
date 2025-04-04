import 'package:gbc_coachia/features/auth/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implémentation du repository d'authentification
class AuthRepositoryImpl {
  /// Clé pour stocker l'état de l'onboarding
  static const String _onboardingKey = 'hasSeenOnboarding';
  
  /// Clé pour stocker l'utilisateur courant
  static const String _currentUserKey = 'currentUser';
  
  /// Utilisateur factice pour la démo
  static final User _mockUser = User(
    id: 'user-123',
    email: 'utilisateur@example.com',
    username: 'utilisateur',
    fullName: 'Utilisateur Test',
    photoUrl: null,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  );
  
  /// Constructeur
  const AuthRepositoryImpl();
  
  /// Obtenir l'utilisateur courant
  Future<User?> getCurrentUser() async {
    // Simuler une attente pour l'API
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Pour le moment, simuler un utilisateur non connecté
    return null;
  }
  
  /// Vérifier si l'onboarding a été vu
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }
  
  /// Marquer l'onboarding comme vu
  Future<void> setOnboardingSeen(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, seen);
  }
  
  /// Connecter un utilisateur
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    // Simuler une attente pour l'API
    await Future.delayed(const Duration(seconds: 1));
    
    // Valider les identifiants (simulation)
    if (email.toLowerCase() != _mockUser.email && password != 'password123') {
      throw Exception('Identifiants invalides');
    }
    
    // Retourner l'utilisateur simulé
    final now = DateTime.now();
    return _mockUser.copyWith(
      updatedAt: now,
    );
  }
  
  /// Inscrire un nouvel utilisateur
  Future<User> signUp({
    required String email,
    required String password,
    required String username,
    String? fullName,
  }) async {
    // Simuler une attente pour l'API
    await Future.delayed(const Duration(seconds: 1));
    
    // Vérifier si l'email est déjà utilisé (simulation)
    if (email.toLowerCase() == _mockUser.email) {
      throw Exception('Cet email est déjà utilisé');
    }
    
    // Simuler la création d'un nouvel utilisateur
    final now = DateTime.now();
    return User(
      id: 'user-${now.millisecondsSinceEpoch}',
      email: email,
      username: username,
      fullName: fullName,
      photoUrl: null,
      createdAt: now,
      updatedAt: now,
    );
  }
  
  /// Déconnecter l'utilisateur
  Future<void> signOut() async {
    // Simuler une attente pour l'API
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Nettoyer les données de session (à implémenter)
  }
  
  /// Mettre à jour le profil utilisateur
  Future<User> updateProfile({
    required String userId,
    String? username,
    String? fullName,
    String? email,
    String? photoUrl,
  }) async {
    // Simuler une attente pour l'API
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Récupérer l'utilisateur actuel (simulation)
    final currentUser = await getCurrentUser();
    if (currentUser == null) {
      throw Exception('Utilisateur non connecté');
    }
    
    // Simuler la mise à jour
    return currentUser.copyWith(
      username: username,
      fullName: fullName,
      email: email,
      photoUrl: photoUrl,
      updatedAt: DateTime.now(),
    );
  }
}
