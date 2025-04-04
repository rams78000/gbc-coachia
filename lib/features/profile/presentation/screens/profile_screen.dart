import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Écran du profil utilisateur
class ProfileScreen extends StatefulWidget {
  /// Constructeur
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _userEmail = '';
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'Français';
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadAppSettings();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'Utilisateur';
      _userEmail = prefs.getString('userEmail') ?? 'utilisateur@example.com';
    });
  }

  Future<void> _loadAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'Français';
    });
  }

  Future<void> _saveAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setString('selectedLanguage', _selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppScaffold(
      title: 'Profil',
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            // Rediriger vers la page de connexion si déconnecté
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/login');
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête du profil
              _ProfileHeader(
                name: _userName,
                email: _userEmail,
              ),
              const SizedBox(height: 24),
              
              // Section des paramètres d'application
              Text(
                'Paramètres de l\'application',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _SettingsCard(
                children: [
                  SwitchListTile(
                    title: const Text('Mode sombre'),
                    subtitle: const Text('Activer le thème sombre'),
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                      _saveAppSettings();
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Notifications'),
                    subtitle: const Text('Activer les notifications'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      _saveAppSettings();
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Langue'),
                    subtitle: Text(_selectedLanguage),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showLanguageDialog();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Section du compte
              Text(
                'Compte',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _SettingsCard(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Informations personnelles'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Implémenter la navigation vers les informations personnelles
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Changer le mot de passe'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Implémenter la navigation vers le changement de mot de passe
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Aide et support'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Implémenter la navigation vers l'aide
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app, color: Colors.red),
                    title: const Text(
                      'Se déconnecter',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: _confirmLogout,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Section À propos
              Text(
                'À propos',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _SettingsCard(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('À propos de GBC CoachIA'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showAboutDialog();
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Conditions d\'utilisation'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Implémenter la navigation vers les conditions d'utilisation
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Politique de confidentialité'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Implémenter la navigation vers la politique de confidentialité
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
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
          _LanguageOption(
            title: 'Français',
            isSelected: _selectedLanguage == 'Français',
            onTap: () {
              setState(() {
                _selectedLanguage = 'Français';
              });
              _saveAppSettings();
              Navigator.pop(context);
            },
          ),
          _LanguageOption(
            title: 'English',
            isSelected: _selectedLanguage == 'English',
            onTap: () {
              setState(() {
                _selectedLanguage = 'English';
              });
              _saveAppSettings();
              Navigator.pop(context);
            },
          ),
          _LanguageOption(
            title: 'Español',
            isSelected: _selectedLanguage == 'Español',
            onTap: () {
              setState(() {
                _selectedLanguage = 'Español';
              });
              _saveAppSettings();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            child: const Text('Se déconnecter'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'GBC CoachIA',
        applicationVersion: 'Version 1.0.0',
        applicationIcon: const Icon(
          Icons.psychology,
          size: 48,
          color: Colors.blue,
        ),
        applicationLegalese:
            '© 2025 GBC CoachIA - Tous droits réservés',
        children: [
          const SizedBox(height: 16),
          const Text(
            'GBC CoachIA est une application d\'aide pour les entrepreneurs et indépendants '
            'avec de l\'assistance IA, de la planification, et des outils financiers.',
          ),
        ],
      ),
    );
  }
}

/// Widget pour l'en-tête du profil
class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileHeader({
    Key? key,
    required this.name,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.primaryColor,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Modifier le profil',
                    onPressed: () {
                      // TODO: Implémenter la navigation vers l'édition du profil
                    },
                    icon: Icons.edit,
                    isPrimary: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget pour une carte de paramètres
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: children,
      ),
    );
  }
}

/// Widget pour une option de langue
class _LanguageOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SimpleDialogOption(
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isSelected ? theme.primaryColor : null,
              fontWeight: isSelected ? FontWeight.bold : null,
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check,
              color: theme.primaryColor,
            ),
        ],
      ),
    );
  }
}
