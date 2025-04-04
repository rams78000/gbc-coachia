import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: const Color(0xFFB87333),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsSection(
            context,
            title: 'Compte',
            items: [
              _buildSettingsItem(
                context,
                icon: Icons.person_outline,
                title: 'Profil',
                onTap: () => context.go('/settings/profile'),
              ),
              _buildSettingsItem(
                context,
                icon: Icons.palette_outlined,
                title: 'Thème et apparence',
                onTap: () => context.go('/settings/theme'),
              ),
            ],
          ),
          _buildSettingsSection(
            context,
            title: 'Préférences',
            items: [
              _buildSettingsItem(
                context,
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () => context.go('/settings/notifications'),
              ),
              _buildSettingsItem(
                context,
                icon: Icons.key_outlined,
                title: 'Clés API',
                onTap: () => context.go('/settings/api-keys'),
              ),
              _buildSettingsItem(
                context,
                icon: Icons.language_outlined,
                title: 'Langue',
                onTap: () => context.go('/settings/language'),
              ),
            ],
          ),
          _buildSettingsSection(
            context,
            title: 'Assistance',
            items: [
              _buildSettingsItem(
                context,
                icon: Icons.help_outline,
                title: 'Tutoriel',
                onTap: () => context.go('/settings/onboarding'),
              ),
              _buildSettingsItem(
                context,
                icon: Icons.privacy_tip_outlined,
                title: 'Confidentialité',
                onTap: () => context.go('/settings/privacy'),
              ),
              _buildSettingsItem(
                context,
                icon: Icons.info_outline,
                title: 'À propos',
                onTap: () => context.go('/settings/about'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB87333),
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFB87333),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
