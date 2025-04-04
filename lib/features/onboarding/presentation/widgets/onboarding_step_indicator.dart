import 'package:flutter/material.dart';

class OnboardingStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color activeColor;
  final Color inactiveColor;

  const OnboardingStepIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor = const Color(0xFFB87333),
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalSteps,
        (index) => _buildDot(index),
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = index == currentStep;
    final isCompleted = index < currentStep;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: isActive ? 24 : 10,
      decoration: BoxDecoration(
        color: isActive || isCompleted ? activeColor : inactiveColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
