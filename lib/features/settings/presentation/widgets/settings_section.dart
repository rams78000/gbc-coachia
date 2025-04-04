import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final String? description;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const SettingsSection({
    super.key,
    required this.title,
    this.description,
    required this.children,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0.5,
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
