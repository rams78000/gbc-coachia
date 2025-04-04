import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/settings/domain/entities/app_settings.dart';
import 'package:gbc_coachia/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:gbc_coachia/features/settings/presentation/widgets/settings_item.dart';
import 'package:gbc_coachia/features/settings/presentation/widgets/settings_section.dart';

/// Page des paramètres de notification
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);
  
  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
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
        title: const Text('Notifications'),
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
                  child: Text(
                    'Préférences de notification',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                RadioListTile<NotificationPreference>(
                  title: Text(NotificationPreference.all.displayName),
                  subtitle: const Text('Recevoir toutes les notifications et alertes'),
                  value: NotificationPreference.all,
                  groupValue: settings.notificationPreference,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SettingsBloc>().add(
                        UpdateNotificationPreferences(
                          preference: value,
                          emailNotifications: settings.emailNotifications,
                        ),
                      );
                    }
                  },
                ),
                
                RadioListTile<NotificationPreference>(
                  title: Text(NotificationPreference.important.displayName),
                  subtitle: const Text('Recevoir uniquement les notifications importantes'),
                  value: NotificationPreference.important,
                  groupValue: settings.notificationPreference,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SettingsBloc>().add(
                        UpdateNotificationPreferences(
                          preference: value,
                          emailNotifications: settings.emailNotifications,
                        ),
                      );
                    }
                  },
                ),
                
                RadioListTile<NotificationPreference>(
                  title: Text(NotificationPreference.none.displayName),
                  subtitle: const Text('Ne recevoir aucune notification'),
                  value: NotificationPreference.none,
                  groupValue: settings.notificationPreference,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SettingsBloc>().add(
                        UpdateNotificationPreferences(
                          preference: value,
                          emailNotifications: settings.emailNotifications,
                        ),
                      );
                    }
                  },
                ),
                
                const SizedBox(height: 24),
                const Divider(),
                
                SettingsSection(
                  title: 'Canaux de notification',
                  children: [
                    SettingsItem(
                      title: 'Notifications par email',
                      subtitle: 'Recevoir des notifications par email',
                      leading: const Icon(Icons.email),
                      trailing: Switch(
                        value: settings.emailNotifications,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(
                            UpdateNotificationPreferences(
                              preference: settings.notificationPreference,
                              emailNotifications: value,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                SettingsSection(
                  title: 'Types de notifications',
                  children: [
                    _buildNotificationTypeItem(
                      'Rappels d\'événements',
                      'Notifications pour les événements à venir dans votre calendrier',
                      Icons.event,
                      true,
                      theme,
                    ),
                    _buildNotificationTypeItem(
                      'Mises à jour financières',
                      'Alertes pour les paiements, factures et analyses financières',
                      Icons.attach_money,
                      true,
                      theme,
                    ),
                    _buildNotificationTypeItem(
                      'Nouveaux documents',
                      'Notifications pour les nouveaux documents générés',
                      Icons.description,
                      true,
                      theme,
                    ),
                    _buildNotificationTypeItem(
                      'Suggestions de l\'IA',
                      'Suggestions et recommandations personnalisées',
                      Icons.lightbulb,
                      true,
                      theme,
                    ),
                    _buildNotificationTypeItem(
                      'Mises à jour de l\'application',
                      'Nouvelles fonctionnalités et améliorations',
                      Icons.system_update,
                      true,
                      theme,
                      showDivider: false,
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Note importante',
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Si vous désactivez les notifications, vous risquez de manquer des rappels importants et des mises à jour concernant vos activités professionnelles.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
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
  
  Widget _buildNotificationTypeItem(
    String title,
    String subtitle,
    IconData icon,
    bool enabled,
    ThemeData theme, {
    bool showDivider = true,
  }) {
    return SettingsItem(
      title: title,
      subtitle: subtitle,
      leading: Icon(icon),
      trailing: Switch(
        value: enabled,
        onChanged: (value) {
          // TODO: Implémenter la logique pour les types de notifications spécifiques
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cette fonctionnalité sera disponible prochainement'),
            ),
          );
        },
      ),
      showDivider: showDivider,
    );
  }
}
