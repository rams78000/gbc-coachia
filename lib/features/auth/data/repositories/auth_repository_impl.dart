import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/auth_repository.dart';

/// Implémentation du repository d'authentification
class AuthRepositoryImpl implements AuthRepository {
  /// Clé utilisée pour stocker l'état de connexion dans SharedPreferences
  static const _loggedInKey = 'isLoggedIn';

  /// Clé utilisée pour stocker l'email de l'utilisateur dans SharedPreferences
  static const _userEmailKey = 'userEmail';

  /// Clé utilisée pour stocker le nom de l'utilisateur dans SharedPreferences
  static const _userNameKey = 'userName';

  @override
  Future<void> login({required String email, required String password}) async {
    // Simuler la latence réseau
    await Future.delayed(const Duration(seconds: 1));

    // Dans une vraie application, on ferait une validation et un appel API ici
    // Pour cette démo, on stocke simplement l'état de connexion
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, email.split('@').first);
  }

  @override
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simuler la latence réseau
    await Future.delayed(const Duration(seconds: 1));

    // Dans une vraie application, on ferait une validation et un appel API ici
    // Pour cette démo, on stocke simplement l'état de connexion
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, name);
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }
}
