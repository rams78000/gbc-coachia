import 'package:flutter/material.dart';

/// Types de boutons disponibles
enum AppButtonType {
  /// Bouton principal
  primary,
  
  /// Bouton secondaire
  secondary,
  
  /// Bouton tertiaire
  tertiary,
  
  /// Bouton de texte
  text,
}

/// Bouton personnalisé pour l'application
class AppButton extends StatelessWidget {
  /// Texte du bouton
  final String text;
  
  /// Action à effectuer lors du clic
  final VoidCallback? onPressed;
  
  /// Type de bouton
  final AppButtonType type;
  
  /// Indique si le bouton est en cours de chargement
  final bool isLoading;
  
  /// Icône à afficher
  final IconData? icon;
  
  /// Indique si l'icône doit être affichée à droite
  final bool iconOnRight;
  
  /// Largeur du bouton
  final double? width;
  
  /// Constructeur
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.iconOnRight = false,
    this.width,
  });
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    // Déterminer le style en fonction du type
    ButtonStyle style;
    Widget? leadingIcon;
    Widget? trailingIcon;
    
    switch (type) {
      case AppButtonType.primary:
        style = ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
        break;
        
      case AppButtonType.secondary:
        style = ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
        break;
        
      case AppButtonType.tertiary:
        style = OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
        break;
        
      case AppButtonType.text:
        style = TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        );
        break;
    }
    
    // Préparer l'icône
    if (icon != null && !isLoading) {
      final iconWidget = Icon(icon, size: 20);
      if (iconOnRight) {
        trailingIcon = iconWidget;
      } else {
        leadingIcon = iconWidget;
      }
    }
    
    // Choisir le type de bouton à afficher
    Widget buttonWidget;
    
    // Contenu du bouton
    Widget buttonContent = isLoading
        ? _buildLoadingIndicator(context)
        : _buildButtonContent(
            context,
            text: text,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
          );
    
    // Construire le bouton selon son type
    switch (type) {
      case AppButtonType.text:
        buttonWidget = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: buttonContent,
        );
        break;
        
      case AppButtonType.tertiary:
        buttonWidget = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: buttonContent,
        );
        break;
        
      default:
        buttonWidget = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: buttonContent,
        );
        break;
    }
    
    // Définir la taille du bouton
    return SizedBox(
      width: width,
      child: buttonWidget,
    );
  }
  
  /// Construire le contenu du bouton
  Widget _buildButtonContent(
    BuildContext context, {
    required String text,
    Widget? leadingIcon,
    Widget? trailingIcon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon,
          const SizedBox(width: 8),
        ],
        Text(text),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          trailingIcon,
        ],
      ],
    );
  }
  
  /// Construire l'indicateur de chargement
  Widget _buildLoadingIndicator(BuildContext context) {
    Color color;
    
    switch (type) {
      case AppButtonType.primary:
        color = Theme.of(context).colorScheme.onPrimary;
        break;
      case AppButtonType.secondary:
        color = Theme.of(context).colorScheme.onPrimaryContainer;
        break;
      default:
        color = Theme.of(context).colorScheme.primary;
        break;
    }
    
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
