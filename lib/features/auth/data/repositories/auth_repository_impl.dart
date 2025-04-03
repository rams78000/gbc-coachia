import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../../../core/constants/app_constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  
  AuthRepositoryImpl({required this.dio});
  
  @override
  Future<bool> login({required String email, required String password}) async {
    try {
      // Simulate successful login for demo purposes
      // In a real app, you would make an API request to your auth server
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userTokenKey, 'demo_token');
      
      // Save user basic info
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', email.split('@').first);
      
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
  
  @override
  Future<bool> register({
    required String name, 
    required String email, 
    required String password
  }) async {
    try {
      // Simulate successful registration for demo purposes
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userTokenKey, 'demo_token');
      
      // Save user basic info
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', name);
      
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }
  
  @override
  Future<bool> isAuthenticated() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(AppConstants.userTokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userTokenKey);
      await prefs.remove('user_email');
      await prefs.remove('user_name');
    } catch (e) {
      print('Logout error: $e');
    }
  }
  
  @override
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? email = prefs.getString('user_email');
      final String? name = prefs.getString('user_name');
      
      if (email != null && name != null) {
        return {
          'email': email,
          'name': name,
          'role': 'User',
          'avatar_url': null,
        };
      }
      return null;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }
  
  @override
  Future<bool> updateProfile({required Map<String, dynamic> userData}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      if (userData.containsKey('name')) {
        await prefs.setString('user_name', userData['name']);
      }
      
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }
  
  @override
  Future<bool> resetPassword({required String email}) async {
    try {
      // Simulate password reset for demo purposes
      return true;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }
}
