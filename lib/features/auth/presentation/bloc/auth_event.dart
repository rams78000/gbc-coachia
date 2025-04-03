part of 'auth_bloc.dart';

/// Authentication event
abstract class AuthEvent extends Equatable {
  /// Creates an AuthEvent
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event to check if user is authenticated
class AuthCheckRequested extends AuthEvent {
  /// Creates an AuthCheckRequested event
  const AuthCheckRequested();
}

/// Event to login user
class AuthLoginRequested extends AuthEvent {
  /// Email
  final String email;
  
  /// Password
  final String password;

  /// Creates an AuthLoginRequested event
  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

/// Event to signup user
class AuthSignupRequested extends AuthEvent {
  /// Email
  final String email;
  
  /// Password
  final String password;
  
  /// Name
  final String name;

  /// Creates an AuthSignupRequested event
  const AuthSignupRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, name];
}

/// Event to logout user
class AuthLogoutRequested extends AuthEvent {
  /// Creates an AuthLogoutRequested event
  const AuthLogoutRequested();
}