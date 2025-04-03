import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implémentation du repository d'authentification (mock pour MVP)
class AuthRepositoryImpl implements AuthRepository {
  /// Constructeur
  AuthRepositoryImpl({required this.sharedPreferences});

  /// Instance de SharedPreferences
  final SharedPreferences sharedPreferences;

  /// Clé pour stocker l'utilisateur connecté
  static const String _currentUserKey = 'current_user';

  /// Clé pour stocker les utilisateurs enregistrés
  static const String _usersKey = 'users';

  @override
  Future<bool> isLoggedIn() async {
    final userJson = sharedPreferences.getString(_currentUserKey);
    return userJson != null;
  }

  @override
  Future<User?> getCurrentUser() async {
    final userJson = sharedPreferences.getString(_currentUserKey);
    if (userJson == null) return null;

    final Map<String, dynamic> userMap = json.decode(userJson);
    return User(
      id: userMap['id'],
      email: userMap['email'],
      name: userMap['name'],
      photoUrl: userMap['photoUrl'],
    );
  }

  @override
  Future<User> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Récupère les utilisateurs enregistrés
    final usersJson = sharedPreferences.getStringList(_usersKey) ?? [];
    
    // Recherche l'utilisateur avec l'email correspondant
    for (final userJson in usersJson) {
      final Map<String, dynamic> userMap = json.decode(userJson);
      if (userMap['email'] == email) {
        // Vérifie le mot de passe
        if (userMap['password'] == password) {
          // Enregistre l'utilisateur connecté
          final user = User(
            id: userMap['id'],
            email: userMap['email'],
            name: userMap['name'],
            photoUrl: userMap['photoUrl'],
          );
          await sharedPreferences.setString(
            _currentUserKey,
            json.encode({
              'id': user.id,
              'email': user.email,
              'name': user.name,
              'photoUrl': user.photoUrl,
            }),
          );
          return user;
        } else {
          throw Exception('Mot de passe incorrect');
        }
      }
    }
    
    throw Exception('Aucun utilisateur trouvé avec cet email');
  }

  @override
  Future<User> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    // Récupère les utilisateurs enregistrés
    final usersJson = sharedPreferences.getStringList(_usersKey) ?? [];
    
    // Vérifie si l'email est déjà utilisé
    for (final userJson in usersJson) {
      final Map<String, dynamic> userMap = json.decode(userJson);
      if (userMap['email'] == email) {
        throw Exception('Cet email est déjà utilisé');
      }
    }
    
    // Crée un nouvel utilisateur
    final String id = const Uuid().v4();
    final user = User(
      id: id,
      email: email,
      name: name,
    );
    
    // Enregistre l'utilisateur
    final userMap = {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'photoUrl': null,
    };
    
    usersJson.add(json.encode(userMap));
    await sharedPreferences.setStringList(_usersKey, usersJson);
    
    // Connecte l'utilisateur
    await sharedPreferences.setString(
      _currentUserKey,
      json.encode({
        'id': user.id,
        'email': user.email,
        'name': user.name,
        'photoUrl': user.photoUrl,
      }),
    );
    
    return user;
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove(_currentUserKey);
  }
}
