import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/settings_item.dart';
import '../widgets/settings_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
        GetIt.instance<SettingsRepository>(),
      )..add(const LoadSettings()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Paramètres'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                // Retour à la page d'accueil si on ne peut pas pop
                context.go('/');
              }
            },
          ),
        ),
        body: const _SettingsPageContent(),
      ),
    );
  }
}

class _SettingsPageContent extends StatelessWidget {
  const _SettingsPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SettingsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Erreur: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<SettingsBloc>().add(const LoadSettings());
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        } else if (state is SettingsLoaded) {
          return _buildSettingsList(context, state);
        }
        
        // État initial ou autre
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildSettingsList(BuildContext context, SettingsLoaded state) {
    final userProfile = state.userProfile;
    final appSettings = state.appSettings;
    
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        // Section Profil
        SettingsSection(
          title: 'Profil',
          children: [
            SettingsItem(
              icon: Icons.person,
              title: userProfile.name,
              subtitle: userProfile.email,
              onTap: () => context.go('/settings/profile'),
              trailing: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                backgroundImage: userProfile.profileImageUrl != null
                  ? NetworkImage(userProfile.profileImageUrl!)
                  : null,
                child: userProfile.profileImageUrl == null
                  ? Text(
                      _getInitials(userProfile.name),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : null,
              ),
            ),
          ],
        ),
        
        // Section Apparence
        SettingsSection(
          title: 'Apparence',
          children: [
            SettingsItem(
              icon: Icons.palette,
              title: 'Thème',
              subtitle: _getThemeModeName(appSettings.themeMode),
              onTap: () => _showThemeBottomSheet(context, appSettings.themeMode),
            ),
          ],
        ),
        
        // Section Notifications
        SettingsSection(
          title: 'Notifications',
          children: [
            SettingsItem(
              icon: Icons.notifications,
              title: 'Paramètres de notification',
              subtitle: _getNotificationLevelName(appSettings.notificationLevel),
              onTap: () => context.go('/settings/notifications'),
            ),
          ],
        ),
        
        // Section API et Intégrations
        SettingsSection(
          title: 'API et Intégrations',
          children: [
            SettingsItem(
              icon: Icons.api,
              title: 'Configuration des API d\'IA',
              subtitle: _getApiConfigStatus(appSettings),
              onTap: () => context.go('/settings/api'),
            ),
          ],
        ),
        
        // Section Confidentialité
        SettingsSection(
          title: 'Confidentialité et Sécurité',
          children: [
            SettingsItem(
              icon: Icons.security,
              title: 'Paramètres de confidentialité',
              subtitle: 'Gestion des données et de la sécurité',
              onTap: () => context.go('/settings/privacy'),
            ),
          ],
        ),
        
        // Section À propos
        SettingsSection(
          title: 'À propos',
          children: [
            SettingsItem(
              icon: Icons.info,
              title: 'À propos de l\'application',
              subtitle: 'Version 1.0.0',
              onTap: () {
                // À implémenter: afficher la page "À propos"
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité à venir')),
                );
              },
            ),
            SettingsItem(
              icon: Icons.help,
              title: 'Aide et support',
              subtitle: 'Obtenir de l\'aide',
              onTap: () {
                // À implémenter: afficher la page d'aide
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité à venir')),
                );
              },
            ),
            SettingsItem(
              icon: Icons.logout,
              title: 'Déconnexion',
              subtitle: 'Se déconnecter de l\'application',
              iconColor: Colors.red,
              showDivider: false,
              onTap: () {
                // À implémenter: logique de déconnexion
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Déconnexion')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
  
  // Méthode pour afficher la sélection du thème
  void _showThemeBottomSheet(BuildContext context, AppThemeMode currentThemeMode) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Choisir un thème',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.brightness_auto),
                title: const Text('Système'),
                subtitle: const Text('Suivre les paramètres du système'),
                selected: currentThemeMode == AppThemeMode.system,
                onTap: () {
                  context.read<SettingsBloc>().add(
                    const UpdateThemeMode(AppThemeMode.system),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text('Clair'),
                subtitle: const Text('Thème clair'),
                selected: currentThemeMode == AppThemeMode.light,
                onTap: () {
                  context.read<SettingsBloc>().add(
                    const UpdateThemeMode(AppThemeMode.light),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Sombre'),
                subtitle: const Text('Thème sombre'),
                selected: currentThemeMode == AppThemeMode.dark,
                onTap: () {
                  context.read<SettingsBloc>().add(
                    const UpdateThemeMode(AppThemeMode.dark),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Méthodes d'aide
  String _getThemeModeName(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return 'Clair';
      case AppThemeMode.dark:
        return 'Sombre';
      case AppThemeMode.system:
        return 'Système';
    }
  }
  
  String _getNotificationLevelName(NotificationLevel level) {
    switch (level) {
      case NotificationLevel.all:
        return 'Toutes les notifications';
      case NotificationLevel.important:
        return 'Notifications importantes uniquement';
      case NotificationLevel.none:
        return 'Aucune notification';
    }
  }
  
  String _getApiConfigStatus(AppSettings settings) {
    final List<String> configuredApis = [];
    
    if (settings.openAiApiKey != null && settings.openAiApiKey!.isNotEmpty) {
      configuredApis.add('OpenAI');
    }
    
    if (settings.deepseekApiKey != null && settings.deepseekApiKey!.isNotEmpty) {
      configuredApis.add('Deepseek');
    }
    
    if (settings.geminiApiKey != null && settings.geminiApiKey!.isNotEmpty) {
      configuredApis.add('Gemini');
    }
    
    if (settings.customApiKey != null && settings.customApiKey!.isNotEmpty) {
      configuredApis.add('API personnalisée');
    }
    
    if (configuredApis.isEmpty) {
      return 'Aucune API configurée';
    } else if (configuredApis.length == 1) {
      return '${configuredApis[0]} configuré';
    } else {
      return '${configuredApis.length} API configurées';
    }
  }
  
  String _getInitials(String name) {
    if (name.isEmpty) return '';
    
    final nameParts = name.trim().split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (name.length > 1) {
      return name.substring(0, 2).toUpperCase();
    } else {
      return name.toUpperCase();
    }
  }
}
