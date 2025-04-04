import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../../domain/entities/auth_status.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoggedIn extends AuthEvent {
  final String email;
  final String password;

  const AuthLoggedIn({
    required this.email, 
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthRegister extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const AuthRegister({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, name];
}

class AuthLoggedOut extends AuthEvent {
  const AuthLoggedOut();
}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final AuthStatus status;

  const AuthSuccess(this.status);

  @override
  List<Object> get props => [status];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences _preferences;
  static const String _authStatusKey = 'auth_status';
  static const String _userDataKey = 'user_data';
  final Uuid _uuid = const Uuid();

  AuthBloc({required SharedPreferences preferences}) 
      : _preferences = preferences,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthRegister>(_onAuthRegister);
    on<AuthLoggedOut>(_onAuthLoggedOut);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final status = _loadAuthStatus();
      
      if (status.isUnknown) {
        // Aucun statut d'authentification enregistré
        emit(AuthSuccess(AuthStatus.unauthenticated()));
      } else {
        // Status connu (authentifié ou non authentifié)
        emit(AuthSuccess(status));
      }
    } catch (e) {
      emit(AuthFailure('Erreur lors de la vérification de l\'authentification: $e'));
    }
  }

  Future<void> _onAuthLoggedIn(
    AuthLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Simuler une vérification des identifiants (dans une vraie application, ce serait une API)
      final isValid = await _verifyCredentials(event.email, event.password);
      
      if (isValid) {
        final userData = _loadUserData();
        final userId = userData?.userId ?? _uuid.v4();
        
        // Vérifier si c'est une première connexion
        final isFirstLogin = userData == null;
        
        final status = isFirstLogin 
            ? AuthStatus.firstTimeAuthenticated(userId)
            : AuthStatus.authenticated(userId);
        
        // Sauvegarder le statut d'authentification
        _saveAuthStatus(status);
        
        // Sauvegarder les données utilisateur si c'est une première connexion
        if (isFirstLogin) {
          _saveUserData(UserData(
            userId: userId,
            email: event.email,
            name: event.email.split('@').first, // Par défaut, utiliser la partie locale de l'email comme nom
          ));
        }
        
        emit(AuthSuccess(status));
      } else {
        emit(const AuthFailure('Email ou mot de passe incorrect'));
      }
    } catch (e) {
      emit(AuthFailure('Erreur lors de la connexion: $e'));
    }
  }

  Future<void> _onAuthRegister(
    AuthRegister event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Vérifier si l'utilisateur existe déjà
      final existingUser = await _checkUserExists(event.email);
      
      if (existingUser) {
        emit(const AuthFailure('Un utilisateur avec cet email existe déjà'));
        return;
      }
      
      // Créer un nouvel utilisateur
      final userId = _uuid.v4();
      final userData = UserData(
        userId: userId,
        email: event.email,
        name: event.name,
      );
      
      // Sauvegarder les données utilisateur
      _saveUserData(userData);
      
      // Définir le statut d'authentification comme première connexion
      final status = AuthStatus.firstTimeAuthenticated(userId);
      _saveAuthStatus(status);
      
      emit(AuthSuccess(status));
    } catch (e) {
      emit(AuthFailure('Erreur lors de l\'inscription: $e'));
    }
  }

  Future<void> _onAuthLoggedOut(
    AuthLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Mettre à jour le statut d'authentification
      _saveAuthStatus(AuthStatus.unauthenticated());
      
      emit(AuthSuccess(AuthStatus.unauthenticated()));
    } catch (e) {
      emit(AuthFailure('Erreur lors de la déconnexion: $e'));
    }
  }

  AuthStatus _loadAuthStatus() {
    final statusJson = _preferences.getString(_authStatusKey);
    
    if (statusJson == null) {
      return AuthStatus.unknown();
    }
    
    try {
      final statusMap = jsonDecode(statusJson) as Map<String, dynamic>;
      
      return AuthStatus(
        state: AuthState.values[statusMap['state'] as int],
        userId: statusMap['userId'] as String?,
        lastAuthTime: statusMap['lastAuthTime'] != null 
            ? DateTime.parse(statusMap['lastAuthTime'] as String)
            : null,
        isFirstLogin: statusMap['isFirstLogin'] as bool,
      );
    } catch (e) {
      // En cas d'erreur, retourner un statut inconnu
      return AuthStatus.unknown();
    }
  }

  void _saveAuthStatus(AuthStatus status) {
    final statusMap = {
      'state': status.state.index,
      'userId': status.userId,
      'lastAuthTime': status.lastAuthTime?.toIso8601String(),
      'isFirstLogin': status.isFirstLogin,
    };
    
    final statusJson = jsonEncode(statusMap);
    _preferences.setString(_authStatusKey, statusJson);
  }

  UserData? _loadUserData() {
    final userDataJson = _preferences.getString(_userDataKey);
    
    if (userDataJson == null) {
      return null;
    }
    
    try {
      final userDataMap = jsonDecode(userDataJson) as Map<String, dynamic>;
      
      return UserData(
        userId: userDataMap['userId'] as String,
        email: userDataMap['email'] as String,
        name: userDataMap['name'] as String,
      );
    } catch (e) {
      return null;
    }
  }

  void _saveUserData(UserData userData) {
    final userDataMap = {
      'userId': userData.userId,
      'email': userData.email,
      'name': userData.name,
    };
    
    final userDataJson = jsonEncode(userDataMap);
    _preferences.setString(_userDataKey, userDataJson);
  }

  // Simulation de vérification des identifiants (dans une vraie application, ce serait une API)
  Future<bool> _verifyCredentials(String email, String password) async {
    // Pour la démonstration, accepter n'importe quel email avec un mot de passe d'au moins 6 caractères
    return password.length >= 6;
  }

  // Simulation de vérification si l'utilisateur existe (dans une vraie application, ce serait une API)
  Future<bool> _checkUserExists(String email) async {
    final userData = _loadUserData();
    return userData != null && userData.email == email;
  }
}

class UserData {
  final String userId;
  final String email;
  final String name;

  UserData({
    required this.userId,
    required this.email,
    required this.name,
  });
}
