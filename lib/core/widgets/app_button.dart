import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

/// Button variants
enum AppButtonVariant {
  /// Primary filled button
  primary,

  /// Outline button
  outline,

  /// Text-only button
  text,
}

/// Button sizes
enum AppButtonSize {
  /// Small button
  small,

  /// Medium button
  medium,

  /// Large button
  large,
}

/// Custom app button
class AppButton extends StatelessWidget {
  /// Constructor
  const AppButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.fullWidth = false,
    this.isLoading = false,
    this.borderRadius,
    this.customColors,
  }) : super(key: key);

  /// Button label text
  final String label;

  /// Button tap handler
  final VoidCallback? onPressed;

  /// Button style variant
  final AppButtonVariant variant;

  /// Button size
  final AppButtonSize size;

  /// Optional icon
  final IconData? icon;

  /// Icon position
  final IconPosition iconPosition;

  /// Should button take full width
  final bool fullWidth;

  /// Is button in loading state
  final bool isLoading;

  /// Custom border radius
  final double? borderRadius;

  /// Custom colors for button
  final AppButtonColors? customColors;

  @override
  Widget build(BuildContext context) {
    // Determine button style based on variant
    final ButtonStyle style = _getButtonStyle(context);

    // Determine padding based on size
    final EdgeInsets padding = _getPadding();

    // Determine content based on loading state, icon, etc.
    Widget content = _buildContent();

    // Create the appropriate button type based on variant
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.outline:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: style,
            child: Padding(
              padding: padding,
              child: content,
            ),
          ),
        );
      case AppButtonVariant.text:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: style,
            child: Padding(
              padding: padding,
              child: content,
            ),
          ),
        );
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? 12.0;
    final colors = customColors ?? _getDefaultColors();

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: colors.background,
          foregroundColor: colors.foreground,
          disabledBackgroundColor: colors.background.withOpacity(0.6),
          disabledForegroundColor: colors.foreground.withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
        );
      case AppButtonVariant.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colors.background,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: colors.background.withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            side: BorderSide(
              color: colors.background,
              width: 1.5,
            ),
          ),
        );
      case AppButtonVariant.text:
        return TextButton.styleFrom(
          foregroundColor: colors.background,
          disabledForegroundColor: colors.background.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  Widget _buildContent() {
    // If loading, show a loading indicator
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    // Text style based on button size
    final TextStyle textStyle = _getTextStyle();

    // If has icon, show icon and text
    if (icon != null) {
      final iconSize = _getIconSize();
      final spacing = iconPosition == IconPosition.left ? const SizedBox(width: 8) : const SizedBox(width: 8);
      final iconWidget = Icon(icon, size: iconSize);

      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: iconPosition == IconPosition.left
            ? [iconWidget, spacing, Text(label, style: textStyle)]
            : [Text(label, style: textStyle), spacing, iconWidget],
      );
    }

    // Just show text
    return Text(label, style: textStyle);
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
      case AppButtonSize.medium:
        return const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
      case AppButtonSize.large:
        return const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 18;
      case AppButtonSize.large:
        return 20;
    }
  }

  AppButtonColors _getDefaultColors() {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppButtonColors(
          background: AppColors.primary,
          foreground: Colors.white,
        );
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
        return AppButtonColors(
          background: AppColors.primary,
          foreground: AppColors.primary,
        );
    }
  }
}

/// Icon position in button
enum IconPosition {
  /// Icon on the left
  left,

  /// Icon on the right
  right,
}

/// Button colors
class AppButtonColors {
  /// Button background color
  final Color background;

  /// Button text color
  final Color foreground;

  /// Constructor
  const AppButtonColors({
    required this.background,
    required this.foreground,
  });
}
