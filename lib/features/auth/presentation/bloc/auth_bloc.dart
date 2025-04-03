import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

/// Authentication event
abstract class AuthEvent extends Equatable {
  /// Constructor
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check authentication status
class AuthCheckRequested extends AuthEvent {
  /// Constructor
  const AuthCheckRequested();
}

/// Login event
class AuthLoginRequested extends AuthEvent {
  /// Constructor
  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  /// Email
  final String email;

  /// Password
  final String password;

  @override
  List<Object> get props => [email, password];
}

/// Register event
class AuthRegisterRequested extends AuthEvent {
  /// Constructor
  const AuthRegisterRequested({
    required this.email,
    required this.password,
  });

  /// Email
  final String email;

  /// Password
  final String password;

  @override
  List<Object> get props => [email, password];
}

/// Logout event
class AuthLogoutRequested extends AuthEvent {
  /// Constructor
  const AuthLogoutRequested();
}

/// Authentication state
abstract class AuthState extends Equatable {
  /// Constructor
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {}

/// Loading state
class AuthLoading extends AuthState {}

/// Authenticated state
class AuthAuthenticated extends AuthState {}

/// Unauthenticated state
class AuthUnauthenticated extends AuthState {}

/// Error state
class AuthError extends AuthState {
  /// Constructor
  const AuthError(this.message);

  /// Error message
  final String message;

  @override
  List<Object> get props => [message];
}

/// Auth bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Constructor
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  /// Auth repository
  final AuthRepository authRepository;

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isAuthenticated = await authRepository.isAuthenticated();
      if (isAuthenticated) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.login(event.email, event.password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.register(event.email, event.password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
