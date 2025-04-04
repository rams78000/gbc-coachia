import 'package:flutter/material.dart';

/// Widget de bouton personnalisé
class CustomButton extends StatelessWidget {
  /// Texte du bouton
  final String text;

  /// Fonction appelée lorsque le bouton est pressé
  final VoidCallback onPressed;

  /// Définit si le bouton est plein ou juste avec une bordure
  final bool isPrimary;

  /// Largeur du bouton (optionnel)
  final double? width;

  /// Icône à afficher avant le texte (optionnel)
  final IconData? icon;

  /// Constructeur
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.width,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: isPrimary ? Colors.white : theme.primaryColor,
          backgroundColor: isPrimary ? theme.primaryColor : Colors.transparent,
          elevation: isPrimary ? 2 : 0,
          side: BorderSide(
            color: theme.primaryColor,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isPrimary ? Colors.white : theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
