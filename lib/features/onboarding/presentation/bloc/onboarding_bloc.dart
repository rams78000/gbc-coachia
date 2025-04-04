import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class OnboardingCheckStatus extends OnboardingEvent {
  const OnboardingCheckStatus();
}

class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}

class OnboardingReset extends OnboardingEvent {
  const OnboardingReset();
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

class OnboardingRequired extends OnboardingState {
  const OnboardingRequired();
}

class OnboardingCompletedState extends OnboardingState {
  const OnboardingCompletedState();
}

// BLoC
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final SharedPreferences _preferences;
  static const String _onboardingCompletedKey = 'onboarding_completed';

  OnboardingBloc({required SharedPreferences preferences}) 
      : _preferences = preferences,
        super(const OnboardingInitial()) {
    on<OnboardingCheckStatus>(_onCheckStatus);
    on<OnboardingCompleted>(_onOnboardingCompleted);
    on<OnboardingReset>(_onOnboardingReset);
  }

  Future<void> _onCheckStatus(
    OnboardingCheckStatus event,
    Emitter<OnboardingState> emit,
  ) async {
    final isCompleted = _preferences.getBool(_onboardingCompletedKey) ?? false;
    
    if (isCompleted) {
      emit(const OnboardingCompletedState());
    } else {
      emit(const OnboardingRequired());
    }
  }

  Future<void> _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    await _preferences.setBool(_onboardingCompletedKey, true);
    emit(const OnboardingCompletedState());
  }

  Future<void> _onOnboardingReset(
    OnboardingReset event,
    Emitter<OnboardingState> emit,
  ) async {
    await _preferences.setBool(_onboardingCompletedKey, false);
    emit(const OnboardingRequired());
  }
}
