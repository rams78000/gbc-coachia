import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: [
          // Section Apparence
          _buildSectionHeader(context, 'Apparence'),
          SwitchListTile(
            title: const Text('Mode sombre'),
            subtitle: const Text('Activer le thème sombre'),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              // Implémenter le changement de thème
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          
          // Section Notifications
          _buildSectionHeader(context, 'Notifications'),
          SwitchListTile(
            title: const Text('Activer les notifications'),
            subtitle: const Text('Recevoir des alertes et des rappels'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // Implémenter la gestion des notifications
            },
            secondary: const Icon(Icons.notifications),
          ),
          
          // Section Langue
          _buildSectionHeader(context, 'Langue'),
          ListTile(
            title: const Text('Langue de l\'application'),
            subtitle: const Text('Français'),
            leading: const Icon(Icons.language),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Ouvrir la sélection de langue
              _showLanguageDialog();
            },
          ),
          
          // Section Compte
          _buildSectionHeader(context, 'Compte'),
          ListTile(
            title: const Text('Informations personnelles'),
            leading: const Icon(Icons.person),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Naviguer vers la page d'informations personnelles
            },
          ),
          ListTile(
            title: const Text('Mot de passe'),
            leading: const Icon(Icons.lock),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Naviguer vers la page de changement de mot de passe
            },
          ),
          
          // Section Assistance
          _buildSectionHeader(context, 'Assistance'),
          ListTile(
            title: const Text('Centre d\'aide'),
            leading: const Icon(Icons.help),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Ouvrir le centre d'aide
            },
          ),
          ListTile(
            title: const Text('Nous contacter'),
            leading: const Icon(Icons.mail),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Ouvrir la page de contact
            },
          ),
          
          // Section À propos
          _buildSectionHeader(context, 'À propos'),
          ListTile(
            title: const Text('Version de l\'application'),
            subtitle: const Text('1.0.0'),
            leading: const Icon(Icons.info),
          ),
          ListTile(
            title: const Text('Conditions d\'utilisation'),
            leading: const Icon(Icons.description),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Ouvrir les conditions d'utilisation
            },
          ),
          ListTile(
            title: const Text('Politique de confidentialité'),
            leading: const Icon(Icons.privacy_tip),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Ouvrir la politique de confidentialité
            },
          ),
          
          // Bouton de déconnexion
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                _showLogoutDialog();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Se déconnecter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choisir une langue'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              // Définir la langue en français
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Français'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              // Définir la langue en anglais
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('English'),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const AuthLoggedOut());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}
