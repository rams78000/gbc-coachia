import 'package:equatable/equatable.dart';

class OnboardingStatus extends Equatable {
  final bool isCompleted;
  final int lastStep;
  final Map<String, dynamic> userPreferences;

  const OnboardingStatus({
    this.isCompleted = false,
    this.lastStep = 0,
    this.userPreferences = const {},
  });

  OnboardingStatus copyWith({
    bool? isCompleted,
    int? lastStep,
    Map<String, dynamic>? userPreferences,
  }) {
    return OnboardingStatus(
      isCompleted: isCompleted ?? this.isCompleted,
      lastStep: lastStep ?? this.lastStep,
      userPreferences: userPreferences ?? this.userPreferences,
    );
  }

  @override
  List<Object?> get props => [isCompleted, lastStep, userPreferences];
}
