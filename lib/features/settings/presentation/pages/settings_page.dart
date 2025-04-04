import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'Français';
  final List<String> _languages = ['Français', 'English', 'Español'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final goldColor = const Color(0xFFFFD700);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(primaryColor, goldColor),
              const SizedBox(height: 24),
              _buildGeneralSettingsSection(primaryColor),
              const SizedBox(height: 24),
              _buildNotificationsSection(primaryColor),
              const SizedBox(height: 24),
              _buildAPIConfigurationSection(primaryColor),
              const SizedBox(height: 24),
              _buildPrivacySection(primaryColor),
              const SizedBox(height: 24),
              _buildHelpSupportSection(primaryColor),
              const SizedBox(height: 24),
              _buildLogoutSection(primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(Color primaryColor, Color goldColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Text(
                  'EP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Entrepreneur Pro',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'entrepreneur@example.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: goldColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Premium',
                        style: TextStyle(
                          color: goldColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Naviguer vers la page de profil
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(double.infinity, 0),
            ),
            child: const Text('Modifier le profil'),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettingsSection(Color primaryColor) {
    return _buildSettingsSection(
      title: 'Général',
      icon: Icons.settings,
      color: primaryColor,
      children: [
        _buildSwitchSetting(
          title: 'Mode sombre',
          subtitle: 'Activer le thème sombre',
          value: _isDarkMode,
          onChanged: (value) {
            setState(() {
              _isDarkMode = value;
              // Implémenter le changement de thème
            });
          },
        ),
        const Divider(),
        _buildLanguageSetting(
          title: 'Langue',
          subtitle: 'Choisir la langue de l\'application',
          value: _selectedLanguage,
          options: _languages,
          onChange: (value) {
            setState(() {
              _selectedLanguage = value;
              // Implémenter le changement de langue
            });
          },
        ),
        const Divider(),
        _buildNavigationSetting(
          title: 'Tutoriel d\'onboarding',
          subtitle: 'Revoir le tutoriel d\'introduction',
          icon: Icons.play_circle_outline,
          onTap: () {
            // Naviguer vers l'onboarding
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(Color primaryColor) {
    return _buildSettingsSection(
      title: 'Notifications',
      icon: Icons.notifications,
      color: primaryColor,
      children: [
        _buildSwitchSetting(
          title: 'Notifications',
          subtitle: 'Activer ou désactiver toutes les notifications',
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        if (_notificationsEnabled) ...[
          const Divider(),
          _buildSwitchSetting(
            title: 'Échéances de factures',
            subtitle: 'Notifications pour les factures à échéance',
            value: true,
            onChanged: (value) {
              // Gérer les préférences de notification
            },
          ),
          const Divider(),
          _buildSwitchSetting(
            title: 'Rappels de tâches',
            subtitle: 'Notifications pour les tâches à venir',
            value: true,
            onChanged: (value) {
              // Gérer les préférences de notification
            },
          ),
          const Divider(),
          _buildSwitchSetting(
            title: 'Conseils IA',
            subtitle: 'Conseils personnalisés de votre assistant IA',
            value: false,
            onChanged: (value) {
              // Gérer les préférences de notification
            },
          ),
        ],
      ],
    );
  }

  Widget _buildAPIConfigurationSection(Color primaryColor) {
    return _buildSettingsSection(
      title: 'Configuration d\'API',
      icon: Icons.cloud,
      color: primaryColor,
      children: [
        _buildNavigationSetting(
          title: 'Connexion API IA',
          subtitle: 'Configurer la clé API pour les fonctionnalités d\'IA',
          icon: Icons.api,
          onTap: () {
            // Ouvrir la configuration API
          },
        ),
        const Divider(),
        _buildNavigationSetting(
          title: 'Services tiers',
          subtitle: 'Configurer des intégrations avec d\'autres services',
          icon: Icons.extension,
          onTap: () {
            // Ouvrir la configuration des services tiers
          },
        ),
      ],
    );
  }

  Widget _buildPrivacySection(Color primaryColor) {
    return _buildSettingsSection(
      title: 'Confidentialité et sécurité',
      icon: Icons.security,
      color: primaryColor,
      children: [
        _buildNavigationSetting(
          title: 'Changer le mot de passe',
          subtitle: 'Modifier votre mot de passe de connexion',
          icon: Icons.lock,
          onTap: () {
            // Naviguer vers la page de changement de mot de passe
          },
        ),
        const Divider(),
        _buildNavigationSetting(
          title: 'Politique de confidentialité',
          subtitle: 'Comment nous protégeons vos données',
          icon: Icons.privacy_tip,
          onTap: () {
            // Ouvrir la politique de confidentialité
          },
        ),
        const Divider(),
        _buildNavigationSetting(
          title: 'Exporter vos données',
          subtitle: 'Télécharger une copie de vos données',
          icon: Icons.download,
          onTap: () {
            // Naviguer vers l'exportation des données
          },
        ),
      ],
    );
  }

  Widget _buildHelpSupportSection(Color primaryColor) {
    return _buildSettingsSection(
      title: 'Aide et support',
      icon: Icons.help,
      color: primaryColor,
      children: [
        _buildNavigationSetting(
          title: 'Centre d\'aide',
          subtitle: 'Consultez notre documentation d\'aide',
          icon: Icons.help_center,
          onTap: () {
            // Ouvrir le centre d'aide
          },
        ),
        const Divider(),
        _buildNavigationSetting(
          title: 'Contacter le support',
          subtitle: 'Obtenir de l\'aide pour résoudre un problème',
          icon: Icons.support_agent,
          onTap: () {
            // Ouvrir le formulaire de contact
          },
        ),
        const Divider(),
        _buildNavigationSetting(
          title: 'À propos de GBC CoachIA',
          subtitle: 'Version 1.0.0',
          icon: Icons.info,
          onTap: () {
            // Afficher les informations sur l'application
          },
        ),
      ],
    );
  }

  Widget _buildLogoutSection(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Implémenter la déconnexion
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Text(
          'Déconnexion',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchSetting({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFB87333), // Copper/bronze
        ),
      ],
    );
  }

  Widget _buildLanguageSetting({
    required String title,
    required String subtitle,
    required String value,
    required List<String> options,
    required Function(String) onChange,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 8,
          underline: Container(
            height: 2,
            color: const Color(0xFFB87333), // Copper/bronze
          ),
          onChanged: (newValue) {
            if (newValue != null) {
              onChange(newValue);
            }
          },
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNavigationSetting({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              icon,
              color: const Color(0xFFB87333), // Copper/bronze
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
