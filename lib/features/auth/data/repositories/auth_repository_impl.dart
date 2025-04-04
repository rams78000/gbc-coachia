import 'dart:convert';
import 'dart:math';
import 'package:gbc_coachia/features/auth/domain/entities/user.dart';
import 'package:gbc_coachia/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implémentation du repository d'authentification
/// 
/// Cette implémentation est un mock pour le MVP. Dans une version ultérieure,
/// elle sera remplacée par une implémentation qui utilise une API réelle.
class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences sharedPreferences;
  static const String _userKey = 'current_user';

  AuthRepositoryImpl({required this.sharedPreferences});

  @override
  Future<User?> getCurrentUser() async {
    final userJson = sharedPreferences.getString(_userKey);
    if (userJson == null) {
      return null;
    }

    try {
      return User.fromJson(userJson);
    } catch (e) {
      await sharedPreferences.remove(_userKey);
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    // Simuler une connexion réseau
    await Future.delayed(const Duration(seconds: 1));

    // Vérification simple du format d'email
    if (!email.contains('@')) {
      throw Exception('Adresse email invalide');
    }

    // Vérification simple du mot de passe
    if (password.length < 6) {
      throw Exception('Le mot de passe doit contenir au moins 6 caractères');
    }

    // Simuler une authentification réussie
    final user = User(
      id: _generateId(),
      email: email,
      nom: email.split('@').first.split('.').last,
      prenom: email.split('@').first.split('.').first,
      dateCreation: DateTime.now(),
    );

    // Sauvegarder l'utilisateur dans les préférences partagées
    await sharedPreferences.setString(_userKey, user.toJson());

    return user;
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove(_userKey);
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    String? nom,
    String? prenom,
  }) async {
    // Simuler une connexion réseau
    await Future.delayed(const Duration(seconds: 1));

    // Vérification simple du format d'email
    if (!email.contains('@')) {
      throw Exception('Adresse email invalide');
    }

    // Vérification simple du mot de passe
    if (password.length < 6) {
      throw Exception('Le mot de passe doit contenir au moins 6 caractères');
    }

    // Simuler un enregistrement réussi
    final user = User(
      id: _generateId(),
      email: email,
      nom: nom,
      prenom: prenom,
      dateCreation: DateTime.now(),
    );

    // Sauvegarder l'utilisateur dans les préférences partagées
    await sharedPreferences.setString(_userKey, user.toJson());

    return user;
  }

  @override
  Future<void> resetPassword({required String email}) async {
    // Simuler une connexion réseau
    await Future.delayed(const Duration(seconds: 1));

    // Vérification simple du format d'email
    if (!email.contains('@')) {
      throw Exception('Adresse email invalide');
    }

    // Dans une implémentation réelle, cette méthode enverrait un email
    // avec un lien pour réinitialiser le mot de passe
  }

  /// Génère un identifiant unique pour l'utilisateur
  String _generateId() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }
}
