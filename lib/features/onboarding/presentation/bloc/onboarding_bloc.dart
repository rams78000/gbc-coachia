import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class OnboardingStatusRequested extends OnboardingEvent {
  const OnboardingStatusRequested();
}

class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
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

class OnboardingNotCompleted extends OnboardingState {
  const OnboardingNotCompleted();
}

class OnboardingIsCompleted extends OnboardingState {
  const OnboardingIsCompleted();
}

// BLoC
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  static const String onboardingCompletedKey = 'onboarding_completed';

  OnboardingBloc() : super(const OnboardingInitial()) {
    on<OnboardingStatusRequested>(_onStatusRequested);
    on<OnboardingCompleted>(_onCompleted);
  }

  Future<void> _onStatusRequested(
    OnboardingStatusRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingLoading());
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final isCompleted = prefs.getBool(onboardingCompletedKey) ?? false;
      
      if (isCompleted) {
        emit(const OnboardingIsCompleted());
      } else {
        emit(const OnboardingNotCompleted());
      }
    } catch (e) {
      // En cas d'erreur, considérer l'onboarding comme non complété
      emit(const OnboardingNotCompleted());
    }
  }

  Future<void> _onCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingLoading());
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(onboardingCompletedKey, true);
      
      emit(const OnboardingIsCompleted());
    } catch (e) {
      // En cas d'erreur, l'onboarding reste non complété
      emit(const OnboardingNotCompleted());
    }
  }
}
