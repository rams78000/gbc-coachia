import 'package:flutter/material.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';

/// Type de message
enum AppMessageType {
  /// Message d'information
  info,
  
  /// Message de succès
  success,
  
  /// Message d'avertissement
  warning,
  
  /// Message d'erreur
  error,
}

/// Widget pour afficher un message avec différents styles
class AppMessage extends StatelessWidget {
  /// Texte du message
  final String message;
  
  /// Type de message
  final AppMessageType type;
  
  /// Icône personnalisée (remplace l'icône par défaut)
  final IconData? icon;
  
  /// Fonction appelée lorsque le bouton de fermeture est appuyé
  final VoidCallback? onClose;
  
  /// Action secondaire (bouton)
  final String? actionLabel;
  
  /// Fonction appelée lorsque le bouton d'action est appuyé
  final VoidCallback? onAction;
  
  /// Indique si le message est dense (moins de padding)
  final bool isDense;

  /// Constructeur
  const AppMessage({
    Key? key,
    required this.message,
    this.type = AppMessageType.info,
    this.icon,
    this.onClose,
    this.actionLabel,
    this.onAction,
    this.isDense = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Configuration des couleurs et icônes en fonction du type
    IconData messageIcon;
    Color backgroundColor;
    Color iconColor;
    
    switch (type) {
      case AppMessageType.info:
        messageIcon = Icons.info_outline;
        backgroundColor = Colors.blue.withOpacity(0.1);
        iconColor = Colors.blue;
        break;
      case AppMessageType.success:
        messageIcon = Icons.check_circle_outline;
        backgroundColor = AppTheme.successColor.withOpacity(0.1);
        iconColor = AppTheme.successColor;
        break;
      case AppMessageType.warning:
        messageIcon = Icons.warning_amber_outlined;
        backgroundColor = Colors.orange.withOpacity(0.1);
        iconColor = Colors.orange;
        break;
      case AppMessageType.error:
        messageIcon = Icons.error_outline;
        backgroundColor = AppTheme.errorColor.withOpacity(0.1);
        iconColor = AppTheme.errorColor;
        break;
    }
    
    // Utiliser l'icône personnalisée si fournie
    messageIcon = icon ?? messageIcon;
    
    return Container(
      padding: EdgeInsets.all(isDense ? AppTheme.spacing1x : AppTheme.spacing2x),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              messageIcon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacing1x),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: AppTheme.spacing1x),
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      foregroundColor: iconColor,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: AppTheme.spacing1x),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              iconSize: 18,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
              splashRadius: 20,
              color: AppTheme.textSecondaryColor,
            ),
          ],
        ],
      ),
    );
  }
}
