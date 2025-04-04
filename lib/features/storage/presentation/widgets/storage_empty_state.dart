import 'package:flutter/material.dart';

/// Widget pour afficher un état vide (aucun fichier ou dossier)
class StorageEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;
  
  const StorageEmptyState({
    Key? key,
    required this.title,
    required this.message,
    this.icon = Icons.folder_open,
    this.onActionPressed,
    this.actionLabel,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64.0,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          if (onActionPressed != null && actionLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: ElevatedButton(
                onPressed: onActionPressed,
                child: Text(actionLabel!),
              ),
            ),
        ],
      ),
    );
  }
}
