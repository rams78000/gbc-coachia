import 'package:flutter/material.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';

/// Badge de notification pour l'application
class NotificationBadge extends StatelessWidget {
  final Widget child;
  final int count;
  final Color color;
  final double size;
  final bool showZero;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const NotificationBadge({
    Key? key,
    required this.child,
    required this.count,
    this.color = AppTheme.errorColor,
    this.size = 18.0,
    this.showZero = false,
    this.textStyle,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Si le compteur est 0 et showZero est false, on n'affiche pas le badge
    if (count == 0 && !showZero) {
      return child;
    }

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: padding ?? const EdgeInsets.all(2),
            constraints: BoxConstraints(
              minWidth: size,
              minHeight: size,
            ),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: textStyle ??
                    TextStyle(
                      color: Colors.white,
                      fontSize: size / 2,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
