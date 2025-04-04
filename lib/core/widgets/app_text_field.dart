import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';

/// Champ de texte personnalisé pour l'application
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final EdgeInsets? contentPadding;
  final bool filled;
  final Color? fillColor;
  final BorderRadius? borderRadius;

  const AppTextField({
    Key? key,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.filled = true,
    this.fillColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = false;
  bool _hasFocus = false;
  final FocusNode _internalFocusNode = FocusNode();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? _internalFocusNode;
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus != _hasFocus) {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = widget.borderRadius ?? BorderRadius.circular(AppTheme.borderRadius);

    final defaultInputBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: theme.dividerColor,
        width: 1,
      ),
    );

    final focusedInputBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(
        color: AppTheme.primaryColor,
        width: 2,
      ),
    );

    final errorInputBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: theme.colorScheme.error,
        width: 1,
      ),
    );

    Widget? suffixIcon;
    if (widget.obscureText) {
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: _hasFocus ? AppTheme.primaryColor : Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.suffix != null) {
      suffixIcon = widget.suffix;
    }

    Widget? prefixIcon;
    if (widget.prefixIcon != null) {
      prefixIcon = Icon(
        widget.prefixIcon,
        color: _hasFocus ? AppTheme.primaryColor : Colors.grey,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppTheme.smallSpacing / 2),
        ],
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          focusNode: _focusNode,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          textCapitalization: widget.textCapitalization,
          inputFormatters: widget.inputFormatters,
          cursorColor: AppTheme.primaryColor,
          decoration: InputDecoration(
            hintText: widget.hintText,
            helperText: widget.helperText,
            errorText: widget.errorText,
            filled: widget.filled,
            fillColor: widget.fillColor ?? 
                (widget.enabled 
                    ? theme.inputDecorationTheme.fillColor 
                    : Colors.grey.shade100),
            contentPadding: widget.contentPadding ?? 
                const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing, 
                  vertical: AppTheme.spacing,
                ),
            prefixIcon: prefixIcon != null 
                ? Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: prefixIcon,
                  ) 
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 42,
              minHeight: 42,
            ),
            suffixIcon: suffixIcon,
            border: defaultInputBorder,
            enabledBorder: defaultInputBorder,
            focusedBorder: focusedInputBorder,
            errorBorder: errorInputBorder,
            focusedErrorBorder: errorInputBorder,
          ),
        ),
      ],
    );
  }
}
