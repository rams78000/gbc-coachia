import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/settings/domain/entities/app_settings.dart';
import 'package:gbc_coachia/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:gbc_coachia/features/settings/presentation/widgets/settings_item.dart';
import 'package:gbc_coachia/features/settings/presentation/widgets/settings_section.dart';

/// Page des paramètres de confidentialité
class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({Key? key}) : super(key: key);
  
  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(LoadSettings());
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confidentialité'),
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.privacy_tip, color: Colors.amber),
                              const SizedBox(width: 8),
                              Text(
                                'Confidentialité et sécurité',
                                style: theme.textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nous prenons votre confidentialité au sérieux. Contrôlez comment vos données sont utilisées dans l\'application.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SettingsSection(
                  title: 'Collecte de données',
                  children: [
                    SettingsItem(
                      title: 'Collecte de données d\'utilisation',
                      subtitle: 'Permettre la collecte de données pour améliorer l\'application',
                      leading: const Icon(Icons.analytics),
                      trailing: Switch(
                        value: settings.dataCollection,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(
                            UpdatePrivacySettings(
                              dataCollection: value,
                              crashReporting: settings.crashReporting,
                            ),
                          );
                        },
                      ),
                    ),
                    SettingsItem(
                      title: 'Rapports de crash',
                      subtitle: 'Envoyer automatiquement des rapports d\'erreur pour aider à résoudre les problèmes',
                      leading: const Icon(Icons.bug_report),
                      trailing: Switch(
                        value: settings.crashReporting,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(
                            UpdatePrivacySettings(
                              dataCollection: settings.dataCollection,
                              crashReporting: value,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                
                SettingsSection(
                  title: 'Sécurité',
                  children: [
                    SettingsItem(
                      title: 'Authentification biométrique',
                      subtitle: 'Utiliser votre empreinte digitale ou la reconnaissance faciale pour vous connecter',
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
                    SettingsItem(
                      title: 'Changer le mot de passe',
                      subtitle: 'Mettre à jour le mot de passe de votre compte',
                      leading: const Icon(Icons.password),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Implémenter la fonctionnalité de changement de mot de passe
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cette fonctionnalité sera disponible prochainement'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                
                SettingsSection(
                  title: 'Données stockées',
                  children: [
                    SettingsItem(
                      title: 'Stockage de documents',
                      subtitle: 'Vos documents sont stockés localement sur votre appareil',
                      leading: const Icon(Icons.description),
                      trailing: const Icon(Icons.check_circle, color: Colors.green),
                    ),
                    SettingsItem(
                      title: 'Chiffrement des données',
                      subtitle: 'Vos données sont chiffrées pour une sécurité supplémentaire',
                      leading: const Icon(Icons.enhanced_encryption),
                      trailing: const Icon(Icons.check_circle, color: Colors.green),
                    ),
                    SettingsItem(
                      title: 'Gérer vos données',
                      subtitle: 'Exporter ou supprimer vos données personnelles',
                      leading: const Icon(Icons.storage),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Gérer vos données'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.download),
                                  title: const Text('Exporter toutes les données'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Export de données sera disponible prochainement'),
                                      ),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete, color: Colors.red),
                                  title: const Text('Supprimer toutes les données'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _showDeleteConfirmationDialog();
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Annuler'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Documents légaux',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLegalDocumentButton(
                        'Politique de confidentialité',
                        Icons.policy,
                        theme,
                      ),
                      const SizedBox(height: 8),
                      _buildLegalDocumentButton(
                        'Conditions d\'utilisation',
                        Icons.description,
                        theme,
                      ),
                      const SizedBox(height: 8),
                      _buildLegalDocumentButton(
                        'Mentions légales',
                        Icons.gavel,
                        theme,
                      ),
                    ],
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
  
  Widget _buildLegalDocumentButton(
    String title,
    IconData icon,
    ThemeData theme,
  ) {
    return OutlinedButton.icon(
      onPressed: () {
        // TODO: Ouvrir le document légal correspondant
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title sera disponible prochainement'),
          ),
        );
      },
      icon: Icon(icon),
      label: Text(title),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        minimumSize: const Size(double.infinity, 0),
      ),
    );
  }
  
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer toutes les données ?'),
        content: const Text(
          'Cette action supprimera définitivement toutes vos données personnelles de l\'application. Cette action est irréversible.\n\nÊtes-vous sûr de vouloir continuer ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implémenter la suppression des données
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Suppression des données sera disponible prochainement'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
