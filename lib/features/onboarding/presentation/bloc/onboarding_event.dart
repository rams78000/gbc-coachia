part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class InitializeOnboarding extends OnboardingEvent {
  final bool fromSettings;

  const InitializeOnboarding({this.fromSettings = false});

  @override
  List<Object> get props => [fromSettings];
}

class NextStep extends OnboardingEvent {}

class PreviousStep extends OnboardingEvent {}

class SkipOnboarding extends OnboardingEvent {}

class CompleteOnboarding extends OnboardingEvent {}

class ResetOnboarding extends OnboardingEvent {}

class SavePreference extends OnboardingEvent {
  final Map<String, dynamic> preferences;

  const SavePreference(this.preferences);

  @override
  List<Object> get props => [preferences];
}
