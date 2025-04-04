import 'package:flutter/material.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';

/// Widget pour afficher les indicateurs de page d'onboarding
class OnboardingPageIndicator extends StatelessWidget {
  /// Nombre total de pages
  final int count;
  
  /// Index de la page actuelle
  final int currentIndex;
  
  /// Taille des indicateurs
  final double size;
  
  /// Espacement entre les indicateurs
  final double spacing;
  
  /// Couleur de l'indicateur actif
  final Color activeColor;
  
  /// Couleur des indicateurs inactifs
  final Color inactiveColor;

  /// Constructeur
  const OnboardingPageIndicator({
    Key? key,
    required this.count,
    required this.currentIndex,
    this.size = 10.0,
    this.spacing = 8.0,
    this.activeColor = AppTheme.primaryColor,
    this.inactiveColor = AppTheme.textSecondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        // Déterminer si cet indicateur est actif
        final isActive = index == currentIndex;
        
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? size * 2.5 : size,
            height: size,
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(size / 2),
            ),
          ),
        );
      }),
    );
  }
}
