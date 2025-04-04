import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/onboarding_status.dart';
import '../../domain/repositories/onboarding_repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository repository;

  OnboardingBloc({required this.repository}) : super(OnboardingInitial()) {
    on<InitializeOnboarding>(_onInitializeOnboarding);
    on<NextStep>(_onNextStep);
    on<PreviousStep>(_onPreviousStep);
    on<SkipOnboarding>(_onSkipOnboarding);
    on<CompleteOnboarding>(_onCompleteOnboarding);
    on<ResetOnboarding>(_onResetOnboarding);
    on<SavePreference>(_onSavePreference);
  }

  Future<void> _onInitializeOnboarding(
    InitializeOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    try {
      final status = await repository.getOnboardingStatus();
      if (status.isCompleted && !event.fromSettings) {
        emit(OnboardingCompleted(status));
      } else {
        emit(OnboardingInProgress(status, currentStep: status.lastStep));
      }
    } catch (e) {
      emit(OnboardingError('Erreur lors de l\'initialisation: $e'));
    }
  }

  Future<void> _onNextStep(
    NextStep event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      final nextStep = currentState.currentStep + 1;
      
      // Limiter le nombre d'étapes à 5 (de 0 à 4)
      if (nextStep > 4) {
        return;
      }
      
      try {
        await repository.updateLastStep(nextStep);
        final updatedStatus = currentState.status.copyWith(lastStep: nextStep);
        emit(OnboardingInProgress(updatedStatus, currentStep: nextStep));
      } catch (e) {
        emit(OnboardingError('Erreur lors du passage à l\'étape suivante: $e'));
      }
    }
  }

  Future<void> _onPreviousStep(
    PreviousStep event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      final previousStep = currentState.currentStep - 1;
      
      // Ne pas aller en-dessous de l'étape 0
      if (previousStep < 0) {
        return;
      }
      
      try {
        await repository.updateLastStep(previousStep);
        final updatedStatus = currentState.status.copyWith(lastStep: previousStep);
        emit(OnboardingInProgress(updatedStatus, currentStep: previousStep));
      } catch (e) {
        emit(OnboardingError('Erreur lors du passage à l\'étape précédente: $e'));
      }
    }
  }

  Future<void> _onSkipOnboarding(
    SkipOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      await repository.markOnboardingComplete();
      final status = await repository.getOnboardingStatus();
      emit(OnboardingCompleted(status));
    } catch (e) {
      emit(OnboardingError('Erreur lors du saut de l\'onboarding: $e'));
    }
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      await repository.markOnboardingComplete();
      final status = await repository.getOnboardingStatus();
      emit(OnboardingCompleted(status));
    } catch (e) {
      emit(OnboardingError('Erreur lors de la complétion de l\'onboarding: $e'));
    }
  }

  Future<void> _onResetOnboarding(
    ResetOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      await repository.resetOnboarding();
      final status = await repository.getOnboardingStatus();
      emit(OnboardingInProgress(status, currentStep: 0));
    } catch (e) {
      emit(OnboardingError('Erreur lors de la réinitialisation: $e'));
    }
  }

  Future<void> _onSavePreference(
    SavePreference event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingInProgress) {
      try {
        await repository.saveUserPreferences(event.preferences);
        final updatedStatus = await repository.getOnboardingStatus();
        emit(
          OnboardingInProgress(
            updatedStatus,
            currentStep: (state as OnboardingInProgress).currentStep,
          ),
        );
      } catch (e) {
        emit(OnboardingError('Erreur lors de l\'enregistrement des préférences: $e'));
      }
    }
  }
}
