import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;

  const AppTextField({
    Key? key,
    this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.autovalidateMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputDecorationTheme = theme.inputDecorationTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppTheme.spacing(1)),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          readOnly: readOnly,
          autofocus: autofocus,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onTap: onTap,
          validator: validator,
          autovalidateMode: autovalidateMode,
          inputFormatters: inputFormatters,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            filled: inputDecorationTheme.filled,
            fillColor: inputDecorationTheme.fillColor,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppTheme.spacing(2),
              vertical: AppTheme.spacing(2),
            ),
            border: inputDecorationTheme.border,
            enabledBorder: inputDecorationTheme.enabledBorder,
            focusedBorder: inputDecorationTheme.focusedBorder,
            errorBorder: inputDecorationTheme.errorBorder,
            focusedErrorBorder: inputDecorationTheme.errorBorder,
          ),
        ),
      ],
    );
  }
}
