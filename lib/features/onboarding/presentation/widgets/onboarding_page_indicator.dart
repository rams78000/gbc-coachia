import 'package:flutter/material.dart';

class OnboardingPageIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;

  const OnboardingPageIndicator({
    Key? key,
    required this.currentIndex,
    required this.pageCount,
    this.activeColor = const Color(0xFFB87333),
    this.inactiveColor = const Color(0xFFE0E0E0),
    this.dotSize = 8.0,
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentIndex;
        
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: isActive ? dotSize * 3 : dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(dotSize / 2),
          ),
        );
      }),
    );
  }
}
