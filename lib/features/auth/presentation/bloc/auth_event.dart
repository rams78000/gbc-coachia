part of 'auth_bloc.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  /// Constructor
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event for when the app starts
class AppStarted extends AuthEvent {
  /// Constructor
  const AppStarted();
}

/// Event for when a login is requested
class LoginRequested extends AuthEvent {
  /// Constructor
  const LoginRequested({
    required this.email,
    required this.password,
  });

  /// Email for login
  final String email;
  
  /// Password for login
  final String password;

  @override
  List<Object> get props => [email, password];
}

/// Event for when a registration is requested
class RegisterRequested extends AuthEvent {
  /// Constructor
  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  /// User's name
  final String name;
  
  /// Email for registration
  final String email;
  
  /// Password for registration
  final String password;

  @override
  List<Object> get props => [name, email, password];
}

/// Event for when a logout is requested
class LogoutRequested extends AuthEvent {
  /// Constructor
  const LogoutRequested();
}

/// Event for when the authentication state changes
class AuthStateChanged extends AuthEvent {
  /// Constructor
  const AuthStateChanged({
    required this.isAuthenticated,
  });

  /// Whether the user is authenticated
  final bool isAuthenticated;

  @override
  List<Object> get props => [isAuthenticated];
}
