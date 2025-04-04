import 'package:flutter/material.dart';

/// Champ de texte personnalisé pour l'application
class AppTextField extends StatelessWidget {
  /// Contrôleur pour le champ de texte
  final TextEditingController? controller;
  
  /// Texte d'invite
  final String? hintText;
  
  /// Label du champ
  final String? labelText;
  
  /// Message d'erreur
  final String? errorText;
  
  /// Texte d'aide
  final String? helperText;
  
  /// Prefixe (icône ou widget)
  final Widget? prefix;
  
  /// Icône de prefixe
  final IconData? prefixIcon;
  
  /// Suffixe (icône ou widget)
  final Widget? suffix;
  
  /// Icône de suffixe
  final IconData? suffixIcon;
  
  /// Action à effectuer lorsque l'icône de suffixe est pressée
  final VoidCallback? onSuffixIconPressed;
  
  /// Type de clavier
  final TextInputType? keyboardType;
  
  /// Indique si le champ est obscurci (mot de passe)
  final bool obscureText;
  
  /// Indique si le champ est en lecture seule
  final bool readOnly;
  
  /// Indique si le champ est activé
  final bool enabled;
  
  /// Nombre maximum de lignes
  final int? maxLines;
  
  /// Nombre minimum de lignes
  final int? minLines;
  
  /// Hauteur maximale
  final double? maxHeight;
  
  /// Action à effectuer lors de la soumission
  final ValueChanged<String>? onSubmitted;
  
  /// Action à effectuer lors du changement de valeur
  final ValueChanged<String>? onChanged;
  
  /// Action à effectuer lorsque le champ est tapé
  final VoidCallback? onTap;
  
  /// Validateur de valeur
  final FormFieldValidator<String>? validator;
  
  /// Mise au point lors de l'initialisation
  final FocusNode? focusNode;
  
  /// Constructeur
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.helperText,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxHeight,
    this.onSubmitted,
    this.onChanged,
    this.onTap,
    this.validator,
    this.focusNode,
  });
  
  @override
  Widget build(BuildContext context) {
    // Préparer le préfixe
    Widget? prefixWidget;
    if (prefix != null) {
      prefixWidget = prefix;
    } else if (prefixIcon != null) {
      prefixWidget = Icon(prefixIcon);
    }
    
    // Préparer le suffixe
    Widget? suffixWidget;
    if (suffix != null) {
      suffixWidget = suffix;
    } else if (suffixIcon != null) {
      suffixWidget = IconButton(
        icon: Icon(suffixIcon),
        onPressed: onSuffixIconPressed,
      );
    }
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          errorText: errorText,
          helperText: helperText,
          prefixIcon: prefixWidget is Icon ? prefixWidget : null,
          prefix: prefixWidget is! Icon ? prefixWidget : null,
          suffixIcon: suffixWidget is Icon || suffixWidget is IconButton
              ? suffixWidget
              : null,
          suffix: suffixWidget is! Icon && suffixWidget is! IconButton
              ? suffixWidget
              : null,
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        readOnly: readOnly,
        enabled: enabled,
        maxLines: maxLines,
        minLines: minLines,
        onFieldSubmitted: onSubmitted,
        onChanged: onChanged,
        onTap: onTap,
        validator: validator,
      ),
    );
  }
}
