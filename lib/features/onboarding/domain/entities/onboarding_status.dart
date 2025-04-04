class OnboardingStatus {
  final bool isCompleted;
  
  const OnboardingStatus({
    required this.isCompleted,
  });
  
  factory OnboardingStatus.initial() {
    return const OnboardingStatus(isCompleted: false);
  }
  
  OnboardingStatus copyWith({
    bool? isCompleted,
  }) {
    return OnboardingStatus(
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
