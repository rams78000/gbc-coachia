part of 'auth_bloc.dart';

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  /// Constructor
  const AuthState();
  
  @override
  List<Object> get props => [];
}

/// Initial authentication state
class AuthInitialState extends AuthState {
  /// Constructor
  const AuthInitialState();
}

/// Loading authentication state
class AuthLoadingState extends AuthState {
  /// Constructor
  const AuthLoadingState();
}

/// Authenticated state
class AuthenticatedState extends AuthState {
  /// Constructor
  const AuthenticatedState({
    required this.user,
  });

  /// User data
  final dynamic user;

  @override
  List<Object> get props => [user];
}

/// Unauthenticated state
class UnauthenticatedState extends AuthState {
  /// Constructor
  const UnauthenticatedState();
}

/// Error authentication state
class AuthErrorState extends AuthState {
  /// Constructor
  const AuthErrorState(this.message);

  /// Error message
  final String message;

  @override
  List<Object> get props => [message];
}
