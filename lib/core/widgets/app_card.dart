import 'package:flutter/material.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';

/// Carte personnalisée pour l'application
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final bool hasShadow;

  const AppCard({
    Key? key,
    required this.child,
    this.onTap,
    this.color,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.hasShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardRadius = borderRadius ?? BorderRadius.circular(AppTheme.borderRadius);
    final cardColor = color ?? theme.cardColor;
    final cardPadding = padding ?? const EdgeInsets.all(AppTheme.spacing);
    final cardMargin = margin ?? const EdgeInsets.all(0);
    final cardElevation = elevation ?? (hasShadow ? 1.0 : 0.0);

    if (onTap != null) {
      return Card(
        color: cardColor,
        elevation: cardElevation,
        margin: cardMargin,
        shape: RoundedRectangleBorder(
          borderRadius: cardRadius,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: cardRadius,
          child: Padding(
            padding: cardPadding,
            child: child,
          ),
        ),
      );
    }

    return Card(
      color: cardColor,
      elevation: cardElevation,
      margin: cardMargin,
      shape: RoundedRectangleBorder(
        borderRadius: cardRadius,
      ),
      child: Padding(
        padding: cardPadding,
        child: child,
      ),
    );
  }
}
