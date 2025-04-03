import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_theme.dart';

enum AppButtonType { primary, secondary, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;
  final double? height;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppButtonType.primary:
        return _buildPrimaryButton(context);
      case AppButtonType.secondary:
        return _buildSecondaryButton(context);
      case AppButtonType.text:
        return _buildTextButton(context);
    }
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height ?? 48.0,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: Theme.of(context).elevatedButtonTheme.style,
        child: _buildButtonContent(
          context,
          AppColors.white,
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height ?? 48.0,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: Theme.of(context).outlinedButtonTheme.style,
        child: _buildButtonContent(
          context,
          Theme.of(context).textTheme.titleLarge?.color ?? AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacing(2),
          vertical: AppTheme.spacing(1),
        ),
        minimumSize: Size(0, height ?? 40.0),
      ),
      child: _buildButtonContent(
        context,
        AppColors.primary,
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context, Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    } else if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: textColor),
          SizedBox(width: AppTheme.spacing(1)),
          Text(
            text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: textColor,
            ),
          ),
        ],
      );
    } else {
      return Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: textColor,
        ),
      );
    }
  }
}
