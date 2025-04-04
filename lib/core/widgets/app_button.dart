import 'package:flutter/material.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';

/// Bouton personnalisé pour l'application
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final bool isFullWidth;
  final Color? color;
  final TextStyle? textStyle;
  final double height;
  final double elevation;
  final EdgeInsets? padding;

  const AppButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.isFullWidth = false,
    this.color,
    this.textStyle,
    this.height = 48.0,
    this.elevation = 0.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppTheme.primaryColor;
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            side: BorderSide(color: buttonColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            elevation: elevation,
          )
        : ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            elevation: elevation,
          );

    final buttonChild = isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon),
                const SizedBox(width: AppTheme.smallSpacing),
              ],
              Text(
                label,
                style: textStyle,
              ),
            ],
          );

    return isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          );
  }
}
