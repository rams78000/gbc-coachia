import 'package:flutter/material.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';

/// Widget d'avatar pour l'application
class Avatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;
  final bool isOnline;

  const Avatar({
    Key? key,
    this.imageUrl,
    this.initials,
    this.size = 40.0,
    this.backgroundColor = AppTheme.primaryColor,
    this.textColor = Colors.white,
    this.onTap,
    this.isOnline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget avatar;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Avatar avec image
      avatar = ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback en cas d'erreur de chargement de l'image
            return _buildInitialsAvatar();
          },
        ),
      );
    } else {
      // Avatar avec initiales
      avatar = _buildInitialsAvatar();
    }

    if (isOnline) {
      avatar = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size / 4,
              height: size / 4,
              decoration: BoxDecoration(
                color: AppTheme.successColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildInitialsAvatar() {
    final initialsText = initials ?? '?';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initialsText,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: size / 2.5,
          ),
        ),
      ),
    );
  }
}
