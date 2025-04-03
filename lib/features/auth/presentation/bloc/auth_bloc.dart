import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<Login>(_onLogin);
    on<Register>(_onRegister);
    on<Logout>(_onLogout);
    on<UpdateProfile>(_onUpdateProfile);
    on<ResetPassword>(_onResetPassword);
  }
  
  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final bool isAuthenticated = await authRepository.isAuthenticated();
      if (isAuthenticated) {
        final userData = await authRepository.getCurrentUser();
        emit(Authenticated(userData: userData ?? {}));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError('Failed to check authentication status'));
    }
  }
  
  Future<void> _onLogin(
    Login event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final success = await authRepository.login(
        email: event.email,
        password: event.password,
      );
      
      if (success) {
        final userData = await authRepository.getCurrentUser();
        emit(Authenticated(userData: userData ?? {}));
      } else {
        emit(AuthError('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthError('Login failed. Please try again.'));
    }
  }
  
  Future<void> _onRegister(
    Register event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final success = await authRepository.register(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      
      if (success) {
        final userData = await authRepository.getCurrentUser();
        emit(Authenticated(userData: userData ?? {}));
      } else {
        emit(AuthError('Registration failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthError('Registration failed. Please try again.'));
    }
  }
  
  Future<void> _onLogout(
    Logout event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed. Please try again.'));
    }
  }
  
  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is Authenticated) {
      emit(AuthLoading());
      try {
        final success = await authRepository.updateProfile(
          userData: event.userData,
        );
        
        if (success) {
          final updatedUserData = await authRepository.getCurrentUser();
          emit(Authenticated(userData: updatedUserData ?? {}));
        } else {
          emit(AuthError('Failed to update profile'));
          emit(currentState);
        }
      } catch (e) {
        emit(AuthError('Failed to update profile'));
        emit(currentState);
      }
    }
  }
  
  Future<void> _onResetPassword(
    ResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final success = await authRepository.resetPassword(
        email: event.email,
      );
      
      if (success) {
        emit(PasswordResetSent());
      } else {
        emit(AuthError('Failed to send password reset'));
      }
    } catch (e) {
      emit(AuthError('Failed to send password reset'));
    }
  }
}
