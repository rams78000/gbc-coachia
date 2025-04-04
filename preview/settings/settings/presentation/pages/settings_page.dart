import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/settings/domain/entities/app_settings.dart';
import 'package:gbc_coachia/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:gbc_coachia/features/settings/presentation/pages/api_settings_page.dart';
import 'package:gbc_coachia/features/settings/presentation/pages/notification_settings_page.dart';
import 'package:gbc_coachia/features/settings/presentation/pages/privacy_settings_page.dart';
import 'package:gbc_coachia/features/settings/presentation/pages/profile_settings_page.dart';
import 'package:gbc_coachia/features/settings/presentation/widgets/settings_item.dart';
import 'package:gbc_coachia/features/settings/presentation/widgets/settings_section.dart';

/// Page principale des paramètres
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(LoadSettings());
    context.read<SettingsBloc>().add(LoadUserProfile());
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          // On vérifie si les paramètres sont chargés
          AppSettings? settings;
          if (state is SettingsLoaded) {
            settings = state.settings;
          } else if (state is SettingsUpdated) {
            settings = state.settings;
          }
          
          if (settings == null) {
            return const Center(
              child: Text('Chargement des paramètres...'),
            );
          }
          
          return SingleChildScrollView(
            child: Column(
              children: [
                SettingsSection(
                  title: 'Paramètres du compte',
                  children: [
                    SettingsItem(
                      title: 'Profil',
                      leading: const Icon(Icons.person),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => const ProfileSettingsPage(),
                          ),
                        );
                      },
                    ),
                    SettingsItem(
                      title: 'Thème',
                      leading: const Icon(Icons.dark_mode),
                      trailing: DropdownButton<AppTheme>(
                        value: settings.theme,
                        underline: const SizedBox(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            context.read<SettingsBloc>().add(UpdateTheme(newValue));
                          }
                        },
                        items: AppTheme.values.map((theme) {
                          return DropdownMenuItem(
                            value: theme,
                            child: Text(theme.displayName),
                          );
                        }).toList(),
                      ),
                    ),
                    SettingsItem(
                      title: 'Authentification biométrique',
                      leading: const Icon(Icons.fingerprint),
                      trailing: Switch(
                        value: settings.useBiometricAuth,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(
                            UpdateAuthSettings(useBiometricAuth: value),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Préférences',
                  children: [
                    SettingsItem(
                      title: 'Notifications',
                      subtitle: 'Gérer les paramètres de notification',
                      leading: const Icon(Icons.notifications),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => const NotificationSettingsPage(),
                          ),
                        );
                      },
                    ),
                    SettingsItem(
                      title: 'Confidentialité',
                      subtitle: 'Gérer vos données et la collecte d\'informations',
                      leading: const Icon(Icons.security),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => const PrivacySettingsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'API et intégrations',
                  children: [
                    SettingsItem(
                      title: 'Configuration de l\'IA',
                      subtitle: 'Configurer les clés API pour les modèles d\'IA',
                      leading: const Icon(Icons.api),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => const ApiSettingsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'À propos',
                  children: [
                    SettingsItem(
                      title: 'Version de l\'application',
                      leading: const Icon(Icons.info),
                      trailing: const Text('1.0.0'),
                      onTap: null,
                    ),
                    SettingsItem(
                      title: 'Conditions d\'utilisation',
                      leading: const Icon(Icons.description),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Ouvrir les conditions d'utilisation
                      },
                    ),
                    SettingsItem(
                      title: 'Politique de confidentialité',
                      leading: const Icon(Icons.privacy_tip),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Ouvrir la politique de confidentialité
                      },
                    ),
                    SettingsItem(
                      title: 'Aide et support',
                      leading: const Icon(Icons.help),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Ouvrir l'aide et le support
                      },
                      showDivider: false,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Réinitialiser les paramètres'),
                          content: const Text(
                            'Êtes-vous sûr de vouloir réinitialiser tous les paramètres aux valeurs par défaut ? Cette action est irréversible.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Annuler'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<SettingsBloc>().add(ResetSettings());
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Réinitialiser'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Réinitialiser tous les paramètres'),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
