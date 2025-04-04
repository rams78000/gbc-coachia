import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';

/// Événements pour le bloc d'authentification
abstract class AuthEvent extends Equatable {
  /// Constructeur
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Événement envoyé au démarrage de l'application
class AppStarted extends AuthEvent {
  /// Constructeur
  const AppStarted();
}

/// Événement envoyé pour la connexion
class LoginRequested extends AuthEvent {
  /// Email de l'utilisateur
  final String email;

  /// Mot de passe de l'utilisateur
  final String password;

  /// Constructeur
  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

/// Événement envoyé pour l'inscription
class SignupRequested extends AuthEvent {
  /// Nom de l'utilisateur
  final String name;

  /// Email de l'utilisateur
  final String email;

  /// Mot de passe de l'utilisateur
  final String password;

  /// Constructeur
  const SignupRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

/// Événement envoyé pour la déconnexion
class LogoutRequested extends AuthEvent {
  /// Constructeur
  const LogoutRequested();
}

/// États pour le bloc d'authentification
abstract class AuthState extends Equatable {
  /// Constructeur
  const AuthState();

  @override
  List<Object> get props => [];
}

/// État initial, vérifie l'authentification
class AuthInitial extends AuthState {}

/// État de chargement pendant l'authentification
class AuthLoading extends AuthState {}

/// État quand l'utilisateur est authentifié
class Authenticated extends AuthState {}

/// État quand l'utilisateur n'est pas authentifié
class Unauthenticated extends AuthState {}

/// État d'erreur d'authentification
class AuthError extends AuthState {
  /// Message d'erreur
  final String message;

  /// Constructeur
  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Bloc gérant l'authentification
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  /// Constructeur
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signup(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(Authenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
