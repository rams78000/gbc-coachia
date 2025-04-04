import 'package:flutter/material.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';

/// Widget d'avatar circulaire avec support pour image, initiales ou icône
class AppAvatar extends StatelessWidget {
  /// URL de l'image (optionnel)
  final String? imageUrl;
  
  /// Initiales (utilisées si imageUrl est null)
  final String? initials;
  
  /// Icône (utilisée si imageUrl et initials sont null)
  final IconData? icon;
  
  /// Taille de l'avatar
  final double size;
  
  /// Couleur de fond (si pas d'image)
  final Color? backgroundColor;
  
  /// Couleur du texte ou de l'icône
  final Color? foregroundColor;
  
  /// Épaisseur de la bordure
  final double borderWidth;
  
  /// Couleur de la bordure
  final Color? borderColor;
  
  /// Fonction appelée lors du tap
  final VoidCallback? onTap;

  /// Constructeur
  const AppAvatar({
    Key? key,
    this.imageUrl,
    this.initials,
    this.icon = Icons.person,
    this.size = 40,
    this.backgroundColor,
    this.foregroundColor,
    this.borderWidth = 0,
    this.borderColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Déterminer les couleurs
    final bgColor = backgroundColor ?? 
        AppTheme.primaryColor.withOpacity(0.2);
    final fgColor = foregroundColor ?? 
        AppTheme.primaryColor;
    
    // Créer le contenu de l'avatar
    Widget avatarContent;
    
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Avatar avec image
      avatarContent = CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: Colors.transparent,
      );
    } else if (initials != null && initials!.isNotEmpty) {
      // Avatar avec initiales
      avatarContent = CircleAvatar(
        radius: size / 2,
        backgroundColor: bgColor,
        child: Text(
          initials!.substring(0, initials!.length > 2 ? 2 : initials!.length).toUpperCase(),
          style: TextStyle(
            color: fgColor,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
          ),
        ),
      );
    } else {
      // Avatar avec icône
      avatarContent = CircleAvatar(
        radius: size / 2,
        backgroundColor: bgColor,
        child: Icon(
          icon,
          color: fgColor,
          size: size * 0.5,
        ),
      );
    }
    
    // Ajouter une bordure si nécessaire
    if (borderWidth > 0) {
      avatarContent = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? theme.dividerColor,
            width: borderWidth,
          ),
        ),
        child: avatarContent,
      );
    }
    
    // Rendre l'avatar cliquable si onTap est fourni
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: avatarContent,
      );
    }
    
    return avatarContent;
  }
}
