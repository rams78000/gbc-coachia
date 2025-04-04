import 'package:gbc_coachia/features/auth/domain/entities/user.dart';

/// Interface pour le repository d'authentification
abstract class AuthRepository {
  /// Récupérer l'utilisateur actuellement connecté
  Future<User?> getCurrentUser();
  
  /// Connecter un utilisateur avec email et mot de passe
  Future<User> signIn({
    required String email,
    required String password,
  });
  
  /// Créer un nouvel utilisateur
  Future<User> signUp({
    required String email,
    required String password,
    required String username,
    String? fullName,
  });
  
  /// Déconnecter l'utilisateur
  Future<void> signOut();
  
  /// Vérifier si l'utilisateur a déjà vu l'onboarding
  Future<bool> hasSeenOnboarding();
  
  /// Marquer l'onboarding comme vu
  Future<void> setOnboardingSeen();
}
