import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? elevation;
  final double? borderRadius;
  final bool fullWidth;
  final VoidCallback? onTap;

  const AppCard({
    Key? key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.fullWidth = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CardTheme cardTheme = Theme.of(context).cardTheme;
    final double radius = borderRadius ?? AppTheme.cardBorderRadius;
    
    Widget card = Card(
      elevation: elevation ?? cardTheme.elevation ?? AppTheme.cardElevation,
      color: backgroundColor ?? cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: padding ?? EdgeInsets.all(AppTheme.spacing(2)),
        child: child,
      ),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: card,
      );
    }

    if (!fullWidth) {
      return IntrinsicWidth(child: card);
    }

    return card;
  }
}
