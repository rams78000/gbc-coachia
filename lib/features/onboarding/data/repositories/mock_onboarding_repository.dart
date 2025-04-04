import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/onboarding_status.dart';
import '../../domain/repositories/onboarding_repository.dart';

class MockOnboardingRepository implements OnboardingRepository {
  static const String _onboardingStatusKey = 'onboarding_status';

  @override
  Future<OnboardingStatus> getOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final statusJson = prefs.getString(_onboardingStatusKey);
    
    if (statusJson == null) {
      return const OnboardingStatus();
    }
    
    try {
      final Map<String, dynamic> statusMap = 
          json.decode(statusJson) as Map<String, dynamic>;
      
      return OnboardingStatus(
        isCompleted: statusMap['isCompleted'] as bool? ?? false,
        lastStep: statusMap['lastStep'] as int? ?? 0,
        userPreferences: statusMap['userPreferences'] as Map<String, dynamic>? ?? {},
      );
    } catch (e) {
      return const OnboardingStatus();
    }
  }

  @override
  Future<void> saveOnboardingStatus(OnboardingStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    final statusMap = {
      'isCompleted': status.isCompleted,
      'lastStep': status.lastStep,
      'userPreferences': status.userPreferences,
    };
    
    await prefs.setString(_onboardingStatusKey, json.encode(statusMap));
  }

  @override
  Future<void> markOnboardingComplete() async {
    final currentStatus = await getOnboardingStatus();
    final updatedStatus = currentStatus.copyWith(isCompleted: true);
    
    await saveOnboardingStatus(updatedStatus);
  }

  @override
  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingStatusKey);
  }

  @override
  Future<void> updateLastStep(int step) async {
    final currentStatus = await getOnboardingStatus();
    final updatedStatus = currentStatus.copyWith(lastStep: step);
    
    await saveOnboardingStatus(updatedStatus);
  }

  @override
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    final currentStatus = await getOnboardingStatus();
    final updatedPreferences = {
      ...currentStatus.userPreferences,
      ...preferences,
    };
    
    final updatedStatus = currentStatus.copyWith(
      userPreferences: updatedPreferences,
    );
    
    await saveOnboardingStatus(updatedStatus);
  }
}
