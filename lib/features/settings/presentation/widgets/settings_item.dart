import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Widget? trailing;
  final bool showDivider;

  const SettingsItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.trailing,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? theme.colorScheme.primary).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor ?? theme.colorScheme.primary,
            ),
          ),
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                )
              : null,
          trailing: trailing ?? const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            color: theme.dividerColor.withOpacity(0.3),
            indent: 70,
            height: 1,
          ),
      ],
    );
  }
}

class SettingsSwitchItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? iconColor;
  final bool showDivider;

  const SettingsSwitchItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.iconColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsItem(
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconColor: iconColor,
      showDivider: showDivider,
      onTap: () {
        onChanged(!value);
      },
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
