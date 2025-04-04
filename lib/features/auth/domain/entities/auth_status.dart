import 'package:equatable/equatable.dart';

enum AuthState {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthStatus extends Equatable {
  final AuthState state;
  final String? userId;
  final DateTime? lastAuthTime;
  final bool isFirstLogin;

  const AuthStatus({
    required this.state,
    this.userId,
    this.lastAuthTime,
    this.isFirstLogin = false,
  });

  factory AuthStatus.unknown() {
    return const AuthStatus(state: AuthState.unknown);
  }

  factory AuthStatus.authenticated(String userId) {
    return AuthStatus(
      state: AuthState.authenticated,
      userId: userId,
      lastAuthTime: DateTime.now(),
      isFirstLogin: false,
    );
  }

  factory AuthStatus.firstTimeAuthenticated(String userId) {
    return AuthStatus(
      state: AuthState.authenticated,
      userId: userId,
      lastAuthTime: DateTime.now(),
      isFirstLogin: true,
    );
  }

  factory AuthStatus.unauthenticated() {
    return const AuthStatus(state: AuthState.unauthenticated);
  }

  bool get isAuthenticated => state == AuthState.authenticated;
  bool get isUnauthenticated => state == AuthState.unauthenticated;
  bool get isUnknown => state == AuthState.unknown;

  @override
  List<Object?> get props => [state, userId, lastAuthTime, isFirstLogin];

  AuthStatus copyWith({
    AuthState? state,
    String? userId,
    DateTime? lastAuthTime,
    bool? isFirstLogin,
  }) {
    return AuthStatus(
      state: state ?? this.state,
      userId: userId ?? this.userId,
      lastAuthTime: lastAuthTime ?? this.lastAuthTime,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
    );
  }
}
