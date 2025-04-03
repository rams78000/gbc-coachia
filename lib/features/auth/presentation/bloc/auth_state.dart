part of 'auth_bloc.dart';

/// Authentication state
abstract class AuthState extends Equatable {
  /// Creates an AuthState
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

/// Initial authentication state
class AuthInitial extends AuthState {
  /// Creates an AuthInitial state
  const AuthInitial();
}

/// Loading authentication state
class AuthLoading extends AuthState {
  /// Creates an AuthLoading state
  const AuthLoading();
}

/// Authenticated state
class Authenticated extends AuthState {
  /// User ID
  final String userId;

  /// Creates an Authenticated state
  const Authenticated({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

/// Unauthenticated state
class Unauthenticated extends AuthState {
  /// Creates an Unauthenticated state
  const Unauthenticated();
}

/// Error authentication state
class AuthError extends AuthState {
  /// Error message
  final String message;

  /// Creates an AuthError state
  const AuthError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}