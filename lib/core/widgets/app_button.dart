import 'package:flutter/material.dart';

/// Types de boutons disponibles
enum AppButtonType {
  /// Bouton principal
  primary,
  
  /// Bouton secondaire
  secondary,
  
  /// Bouton avec contour
  outline,
  
  /// Bouton texte
  text,
}

/// Bouton personnalisé pour l'application
class AppButton extends StatelessWidget {
  /// Constructeur
  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.borderRadius = 8.0,
    this.padding,
  }) : super(key: key);

  /// Texte du bouton
  final String label;
  
  /// Action au clic
  final VoidCallback? onPressed;
  
  /// Type de bouton
  final AppButtonType type;
  
  /// Icône optionnelle
  final IconData? icon;
  
  /// Indicateur de chargement
  final bool isLoading;
  
  /// Bouton pleine largeur
  final bool isFullWidth;
  
  /// Rayon de la bordure
  final double borderRadius;
  
  /// Padding personnalisé
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (type) {
      case AppButtonType.primary:
        return _buildElevatedButton(
          context: context,
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        );
      case AppButtonType.secondary:
        return _buildElevatedButton(
          context: context,
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
        );
      case AppButtonType.outline:
        return _buildOutlinedButton(context: context);
      case AppButtonType.text:
        return _buildTextButton(context: context);
    }
  }

  /// Construit un ElevatedButton
  Widget _buildElevatedButton({
    required BuildContext context,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: isFullWidth ? const Size(double.infinity, 56) : null,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: _buildContent(color: foregroundColor),
    );
  }

  /// Construit un OutlinedButton
  Widget _buildOutlinedButton({required BuildContext context}) {
    final primary = Theme.of(context).colorScheme.primary;
    
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        minimumSize: isFullWidth ? const Size(double.infinity, 56) : null,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        side: BorderSide(color: primary),
      ),
      child: _buildContent(color: primary),
    );
  }

  /// Construit un TextButton
  Widget _buildTextButton({required BuildContext context}) {
    final primary = Theme.of(context).colorScheme.primary;
    
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: primary,
        minimumSize: isFullWidth ? const Size(double.infinity, 56) : null,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: _buildContent(color: primary),
    );
  }

  /// Construit le contenu du bouton
  Widget _buildContent({required Color color}) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }
    
    return Text(label);
  }
}
