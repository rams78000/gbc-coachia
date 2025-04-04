import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}

class OnboardingCheckStatus extends OnboardingEvent {
  const OnboardingCheckStatus();
}

// States
abstract class OnboardingState extends Equatable {
  const OnboardingState();
  
  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

class OnboardingRequired extends OnboardingState {
  const OnboardingRequired();
}

class OnboardingNotRequired extends OnboardingState {
  const OnboardingNotRequired();
}

// BLoC
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingInitial()) {
    on<OnboardingCheckStatus>(_onCheckStatus);
    on<OnboardingCompleted>(_onOnboardingCompleted);
  }

  static const String _onboardingCompletedKey = 'onboarding_completed';

  Future<void> _onCheckStatus(
    OnboardingCheckStatus event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingLoading());
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final isCompleted = prefs.getBool(_onboardingCompletedKey) ?? false;
      
      if (isCompleted) {
        emit(const OnboardingNotRequired());
      } else {
        emit(const OnboardingRequired());
      }
    } catch (e) {
      // En cas d'erreur, toujours montrer l'onboarding pour éviter les problèmes
      emit(const OnboardingRequired());
    }
  }

  Future<void> _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingLoading());
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, true);
      
      emit(const OnboardingNotRequired());
    } catch (e) {
      // En cas d'erreur, on considère quand même l'onboarding comme terminé pour cette session
      emit(const OnboardingNotRequired());
    }
  }
}
