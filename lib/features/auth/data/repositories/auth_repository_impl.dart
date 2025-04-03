import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  /// Mock user token for testing
  String? _token;
  
  /// Mock user ID for testing
  String? _userId;
  
  /// Uuid generator
  final Uuid _uuid = const Uuid();

  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    // TODO: Implement with API
    await Future.delayed(const Duration(seconds: 1));
    
    _token = _uuid.v4();
    _userId = _uuid.v4();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', _token!);
    await prefs.setString('user_id', _userId!);
    
    return _token!;
  }

  @override
  Future<String> signUpWithEmailAndPassword(String email, String password, String name) async {
    // TODO: Implement with API
    await Future.delayed(const Duration(seconds: 1));
    
    _token = _uuid.v4();
    _userId = _uuid.v4();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', _token!);
    await prefs.setString('user_id', _userId!);
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    
    return _token!;
  }

  @override
  Future<void> signOut() async {
    // TODO: Implement with API
    _token = null;
    _userId = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    
    return;
  }

  @override
  Future<String?> getToken() async {
    if (_token != null) {
      return _token;
    }
    
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    
    return _token;
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  @override
  Future<String?> getUserId() async {
    if (_userId != null) {
      return _userId;
    }
    
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('user_id');
    
    return _userId;
  }
}