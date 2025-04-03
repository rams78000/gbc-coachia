import 'package:flutter/material.dart';

/// Onboarding slide widget
class OnboardingSlide extends StatelessWidget {
  /// Constructor
  const OnboardingSlide({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    this.imageWidget,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  /// Slide title
  final String title;
  
  /// Slide description
  final String description;
  
  /// Image path
  final String image;
  
  /// Custom image widget
  final Widget? imageWidget;
  
  /// Icon
  final IconData? icon;
  
  /// Icon color
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image or icon
          if (imageWidget != null)
            SizedBox(
              height: 220,
              child: imageWidget!,
            )
          else if (image.isNotEmpty)
            SizedBox(
              height: 220,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            )
          else if (icon != null)
            Icon(
              icon,
              size: 100,
              color: iconColor ?? Theme.of(context).primaryColor,
            ),
          const SizedBox(height: 40),
          
          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // Description
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
