import 'package:flutter/material.dart';

/// Types de boutons disponibles
enum AppButtonType {
  /// Bouton principal
  primary,

  /// Bouton secondaire
  secondary,

  /// Bouton de texte
  text,

  /// Bouton d'action flottant
  floating,
}

/// Widget de bouton personnalisé
class AppButton extends StatelessWidget {
  /// Texte du bouton
  final String text;

  /// Fonction appelée lors du clic
  final VoidCallback? onPressed;

  /// Type de bouton
  final AppButtonType type;

  /// Icône à afficher (optionnel)
  final IconData? icon;

  /// Affichage de l'icône avant le texte
  final bool iconLeading;

  /// Largeur du bouton
  final double? width;

  /// Hauteur du bouton
  final double? height;

  /// Constructeur
  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.iconLeading = true,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Styles pour les différents types de boutons
    switch (type) {
      case AppButtonType.primary:
        return _buildElevatedButton(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          context: context,
        );
      case AppButtonType.secondary:
        return _buildElevatedButton(
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
          context: context,
        );
      case AppButtonType.text:
        return _buildTextButton(
          foregroundColor: theme.colorScheme.primary,
          context: context,
        );
      case AppButtonType.floating:
        return _buildFloatingActionButton(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          context: context,
        );
    }
  }

  /// Construit un ElevatedButton
  Widget _buildElevatedButton({
    required Color backgroundColor,
    required Color foregroundColor,
    required BuildContext context,
  }) {
    final buttonContent = _buildButtonContent(foregroundColor, context);

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: buttonContent,
      ),
    );
  }

  /// Construit un TextButton
  Widget _buildTextButton({
    required Color foregroundColor,
    required BuildContext context,
  }) {
    final buttonContent = _buildButtonContent(foregroundColor, context);

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
        ),
        child: buttonContent,
      ),
    );
  }

  /// Construit un FloatingActionButton
  Widget _buildFloatingActionButton({
    required Color backgroundColor,
    required Color foregroundColor,
    required BuildContext context,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: icon != null
          ? Icon(icon)
          : Text(
              text,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: foregroundColor,
                  ),
            ),
    );
  }

  /// Construit le contenu du bouton (texte et/ou icône)
  Widget _buildButtonContent(Color foregroundColor, BuildContext context) {
    if (icon != null) {
      return iconLeading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: foregroundColor),
                const SizedBox(width: 8),
                Text(text),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text),
                const SizedBox(width: 8),
                Icon(icon, color: foregroundColor),
              ],
            );
    }
    return Text(text);
  }
}
