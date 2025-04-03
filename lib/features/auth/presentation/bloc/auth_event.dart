part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class Login extends AuthEvent {
  final String email;
  final String password;

  const Login({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class Register extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const Register({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

class Logout extends AuthEvent {}

class UpdateProfile extends AuthEvent {
  final Map<String, dynamic> userData;

  const UpdateProfile({required this.userData});

  @override
  List<Object> get props => [userData];
}

class ResetPassword extends AuthEvent {
  final String email;

  const ResetPassword({required this.email});

  @override
  List<Object> get props => [email];
}
