part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
  
  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingInProgress extends OnboardingState {
  final OnboardingStatus status;
  final int currentStep;

  const OnboardingInProgress(this.status, {required this.currentStep});

  @override
  List<Object> get props => [status, currentStep];
}

class OnboardingCompleted extends OnboardingState {
  final OnboardingStatus status;

  const OnboardingCompleted(this.status);

  @override
  List<Object> get props => [status];
}

class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object> get props => [message];
}
