import '../entities/onboarding_status.dart';

abstract class OnboardingRepository {
  Future<OnboardingStatus> getOnboardingStatus();
  Future<void> saveOnboardingStatus(OnboardingStatus status);
  Future<void> markOnboardingComplete();
  Future<void> resetOnboarding();
  Future<void> updateLastStep(int step);
  Future<void> saveUserPreferences(Map<String, dynamic> preferences);
}
