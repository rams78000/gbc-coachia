import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbc_coachia/config/theme/app_colors.dart';

/// Custom app text field
class AppTextField extends StatefulWidget {
  /// Constructor
  const AppTextField({
    Key? key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
    this.initialValue,
    this.autovalidateMode,
  }) : super(key: key);

  /// Text controller
  final TextEditingController? controller;
  
  /// Field label
  final String? label;
  
  /// Hint text
  final String? hint;
  
  /// Prefix icon
  final Widget? prefixIcon;
  
  /// Suffix icon
  final Widget? suffixIcon;
  
  /// Keyboard type
  final TextInputType? keyboardType;
  
  /// Is password field
  final bool obscureText;
  
  /// Maximum length
  final int? maxLength;
  
  /// Maximum lines
  final int? maxLines;
  
  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;
  
  /// Validator function
  final String? Function(String?)? validator;
  
  /// On text changed callback
  final void Function(String)? onChanged;
  
  /// On form submitted callback
  final void Function(String)? onSubmitted;
  
  /// Should autofocus
  final bool autofocus;
  
  /// Is field enabled
  final bool enabled;
  
  /// Is field read-only
  final bool readOnly;
  
  /// Initial value
  final String? initialValue;
  
  /// Auto validate mode
  final AutovalidateMode? autovalidateMode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late TextEditingController _controller;
  bool _isControllerProvided = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    if (widget.controller != null) {
      _controller = widget.controller!;
      _isControllerProvided = true;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
    }
  }

  @override
  void dispose() {
    if (!_isControllerProvided) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
            counterText: '',
          ),
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          maxLength: widget.maxLength,
          maxLines: _obscureText ? 1 : widget.maxLines,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autovalidateMode: widget.autovalidateMode,
        ),
      ],
    );
  }
}
