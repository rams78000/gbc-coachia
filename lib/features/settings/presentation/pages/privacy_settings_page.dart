import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/repositories/settings_repository.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_item.dart';

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
        GetIt.instance<SettingsRepository>(),
      )..add(const LoadSettings()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Confidentialité et Sécurité'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/settings'),
          ),
        ),
        body: const _PrivacySettingsContent(),
      ),
    );
  }
}

class _PrivacySettingsContent extends StatelessWidget {
  const _PrivacySettingsContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        if (state is SettingsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SettingsLoaded) {
          final appSettings = state.appSettings;
          
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              SettingsSection(
                title: 'Collecte de données',
                description: 'Contrôlez les données collectées par l\'application',
                children: [
                  SettingsSwitchItem(
                    icon: Icons.analytics,
                    title: 'Analytique',
                    subtitle: 'Aider à améliorer l\'application en partageant des données d\'utilisation anonymes',
                    value: appSettings.analyticsEnabled,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                        UpdateAnalytics(value),
                      );
                    },
                  ),
                  SettingsSwitchItem(
                    icon: Icons.bug_report,
                    title: 'Rapports de crash',
                    subtitle: 'Envoyer des rapports de crash pour améliorer la stabilité',
                    value: appSettings.crashReportingEnabled,
                    showDivider: false,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                        UpdateCrashReporting(value),
                      );
                    },
                  ),
                ],
              ),
              
              SettingsSection(
                title: 'Sécurité',
                description: 'Protégez vos données et votre compte',
                children: [
                  SettingsSwitchItem(
                    icon: Icons.fingerprint,
                    title: 'Authentification biométrique',
                    subtitle: 'Utiliser votre empreinte digitale ou la reconnaissance faciale pour vous connecter',
                    value: appSettings.biometricAuthEnabled,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                        UpdateBiometricAuth(value),
                      );
                    },
                  ),
                  SettingsItem(
                    icon: Icons.password,
                    title: 'Changer de mot de passe',
                    subtitle: 'Modifier votre mot de passe de connexion',
                    onTap: () {
                      // À implémenter: changement de mot de passe
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fonctionnalité à venir')),
                      );
                    },
                  ),
                  SettingsItem(
                    icon: Icons.security,
                    title: 'Authentification à deux facteurs',
                    subtitle: 'Ajouter une couche de sécurité supplémentaire à votre compte',
                    showDivider: false,
                    onTap: () {
                      // À implémenter: 2FA
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fonctionnalité à venir')),
                      );
                    },
                  ),
                ],
              ),
              
              SettingsSection(
                title: 'Gestion des données',
                description: 'Gérez vos données personnelles',
                children: [
                  SettingsItem(
                    icon: Icons.file_download,
                    title: 'Exporter vos données',
                    subtitle: 'Télécharger une copie de vos données',
                    onTap: () {
                      // À implémenter: export des données
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fonctionnalité à venir')),
                      );
                    },
                  ),
                  SettingsItem(
                    icon: Icons.delete_forever,
                    title: 'Supprimer le compte',
                    subtitle: 'Supprimer définitivement votre compte et vos données',
                    iconColor: Colors.red,
                    showDivider: false,
                    onTap: () {
                      _showDeleteAccountDialog(context);
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
                      'Politique de confidentialité',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pour en savoir plus sur la façon dont nous traitons vos données, consultez notre politique de confidentialité.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        // À implémenter: afficher la politique de confidentialité
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fonctionnalité à venir')),
                        );
                      },
                      child: const Text('Voir la politique de confidentialité'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        
        // État initial ou autre
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
  
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le compte'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible et toutes vos données seront définitivement perdues.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // À implémenter: logique de suppression de compte
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonctionnalité à venir')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
