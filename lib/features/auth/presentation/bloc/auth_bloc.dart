import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gbc_coachia/features/auth/domain/entities/user.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_event.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_state.dart';

/// Bloc d'authentification pour gérer l'état d'authentification de l'application
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Repository d'authentification
  final AuthRepositoryImpl _authRepository;
  
  /// Constructeur
  AuthBloc({required AuthRepositoryImpl authRepository})
      : _authRepository = authRepository,
        super(const AuthInitialState()) {
    // Enregistrement des gestionnaires d'événements
    on<AuthCheckStatusEvent>(_onCheckStatus);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignOutEvent>(_onSignOut);
    on<AuthSetOnboardingSeenEvent>(_onSetOnboardingSeen);
    on<AuthUpdateProfileEvent>(_onUpdateProfile);
  }
  
  /// Vérifier l'état d'authentification actuel
  Future<void> _onCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    
    try {
      // Vérifier si l'utilisateur est connecté
      final user = await _authRepository.getCurrentUser();
      final hasSeenOnboarding = await _authRepository.hasSeenOnboarding();
      
      if (user != null) {
        emit(AuthAuthenticatedState(
          user: user,
          hasSeenOnboarding: hasSeenOnboarding,
        ));
      } else {
        emit(AuthUnauthenticatedState(
          hasSeenOnboarding: hasSeenOnboarding,
        ));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
      emit(const AuthUnauthenticatedState());
    }
  }
  
  /// Se connecter avec email et mot de passe
  Future<void> _onSignIn(
    AuthSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    
    try {
      // Se connecter avec les identifiants
      final user = await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      
      final hasSeenOnboarding = await _authRepository.hasSeenOnboarding();
      
      emit(AuthAuthenticatedState(
        user: user,
        hasSeenOnboarding: hasSeenOnboarding,
      ));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
      
      // Revenir à l'état non authentifié
      final hasSeenOnboarding = await _authRepository.hasSeenOnboarding();
      emit(AuthUnauthenticatedState(
        hasSeenOnboarding: hasSeenOnboarding,
      ));
    }
  }
  
  /// S'inscrire avec email et mot de passe
  Future<void> _onSignUp(
    AuthSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    
    try {
      // Créer un nouvel utilisateur
      final user = await _authRepository.signUp(
        email: event.email,
        password: event.password,
        username: event.username,
        fullName: event.fullName,
      );
      
      final hasSeenOnboarding = await _authRepository.hasSeenOnboarding();
      
      emit(AuthAuthenticatedState(
        user: user,
        hasSeenOnboarding: hasSeenOnboarding,
      ));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
      
      // Revenir à l'état non authentifié
      final hasSeenOnboarding = await _authRepository.hasSeenOnboarding();
      emit(AuthUnauthenticatedState(
        hasSeenOnboarding: hasSeenOnboarding,
      ));
    }
  }
  
  /// Se déconnecter
  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    
    try {
      // Déconnecter l'utilisateur
      await _authRepository.signOut();
      
      final hasSeenOnboarding = await _authRepository.hasSeenOnboarding();
      
      emit(AuthUnauthenticatedState(
        hasSeenOnboarding: hasSeenOnboarding,
      ));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
      
      // En cas d'erreur, vérifier l'état actuel
      final user = await _authRepository.getCurrentUser();
      final hasSeenOnboarding = await _authRepository.hasSeenOnboarding();
      
      if (user != null) {
        emit(AuthAuthenticatedState(
          user: user,
          hasSeenOnboarding: hasSeenOnboarding,
        ));
      } else {
        emit(AuthUnauthenticatedState(
          hasSeenOnboarding: hasSeenOnboarding,
        ));
      }
    }
  }
  
  /// Marquer l'onboarding comme vu
  Future<void> _onSetOnboardingSeen(
    AuthSetOnboardingSeenEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Marquer l'onboarding comme vu
      await _authRepository.setOnboardingSeen(true);
      
      // Mettre à jour l'état
      if (state is AuthAuthenticatedState) {
        final authState = state as AuthAuthenticatedState;
        emit(authState.copyWith(hasSeenOnboarding: true));
      } else if (state is AuthUnauthenticatedState) {
        final authState = state as AuthUnauthenticatedState;
        emit(authState.copyWith(hasSeenOnboarding: true));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
      
      // Rétablir l'état précédent
      emit(state);
    }
  }
  
  /// Mettre à jour le profil utilisateur
  Future<void> _onUpdateProfile(
    AuthUpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticatedState) {
      return;
    }
    
    final currentState = state as AuthAuthenticatedState;
    emit(const AuthLoadingState());
    
    try {
      // Mettre à jour le profil
      final updatedUser = await _authRepository.updateProfile(
        userId: currentState.user.id,
        username: event.username,
        fullName: event.fullName,
        email: event.email,
        photoUrl: event.photoUrl,
      );
      
      emit(currentState.copyWith(user: updatedUser));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
      
      // Rétablir l'état précédent
      emit(currentState);
    }
  }
}
