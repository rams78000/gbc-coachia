import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_item.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
        GetIt.instance<SettingsRepository>(),
      )..add(const LoadSettings()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Paramètres de notification'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/settings'),
          ),
        ),
        body: const _NotificationSettingsContent(),
      ),
    );
  }
}

class _NotificationSettingsContent extends StatelessWidget {
  const _NotificationSettingsContent();

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
                title: 'Niveau de notification',
                description: 'Choisissez quelles notifications vous souhaitez recevoir',
                children: [
                  RadioListTile<NotificationLevel>(
                    title: const Text('Toutes les notifications'),
                    subtitle: const Text('Recevoir toutes les notifications de l\'application'),
                    value: NotificationLevel.all,
                    groupValue: appSettings.notificationLevel,
                    onChanged: (NotificationLevel? value) {
                      if (value != null) {
                        context.read<SettingsBloc>().add(
                          UpdateNotificationLevel(value),
                        );
                      }
                    },
                  ),
                  RadioListTile<NotificationLevel>(
                    title: const Text('Notifications importantes uniquement'),
                    subtitle: const Text('Recevoir uniquement les notifications importantes'),
                    value: NotificationLevel.important,
                    groupValue: appSettings.notificationLevel,
                    onChanged: (NotificationLevel? value) {
                      if (value != null) {
                        context.read<SettingsBloc>().add(
                          UpdateNotificationLevel(value),
                        );
                      }
                    },
                  ),
                  RadioListTile<NotificationLevel>(
                    title: const Text('Aucune notification'),
                    subtitle: const Text('Désactiver toutes les notifications'),
                    value: NotificationLevel.none,
                    groupValue: appSettings.notificationLevel,
                    onChanged: (NotificationLevel? value) {
                      if (value != null) {
                        context.read<SettingsBloc>().add(
                          UpdateNotificationLevel(value),
                        );
                      }
                    },
                  ),
                ],
              ),
              
              if (appSettings.notificationLevel != NotificationLevel.none) ...[
                SettingsSection(
                  title: 'Canaux de notification',
                  description: 'Choisissez comment vous souhaitez être notifié',
                  children: [
                    SettingsSwitchItem(
                      icon: Icons.notifications,
                      title: 'Notifications push',
                      subtitle: 'Recevoir des notifications sur votre appareil',
                      value: appSettings.pushNotificationsEnabled,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          UpdatePushNotifications(value),
                        );
                      },
                    ),
                    SettingsSwitchItem(
                      icon: Icons.email,
                      title: 'Notifications par email',
                      subtitle: 'Recevoir des notifications par email',
                      value: appSettings.emailNotificationsEnabled,
                      showDivider: false,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          UpdateEmailNotifications(value),
                        );
                      },
                    ),
                  ],
                ),
                
                SettingsSection(
                  title: 'Exemples de notifications',
                  description: 'Aperçu des différents types de notifications que vous pouvez recevoir',
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.calendar_today, color: Colors.white),
                      ),
                      title: const Text('Rappel de rendez-vous'),
                      subtitle: const Text('Rendez-vous client dans 1 heure'),
                      trailing: const Text('Aujourd\'hui'),
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.payments, color: Colors.white),
                      ),
                      title: const Text('Facture payée'),
                      subtitle: const Text('La facture #2023-042 a été payée'),
                      trailing: const Text('Hier'),
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.warning, color: Colors.white),
                      ),
                      title: const Text('Échéance de tâche'),
                      subtitle: const Text('La tâche "Finaliser le rapport" est due demain'),
                      trailing: const Text('Important'),
                      showDivider: false,
                    ),
                  ],
                ),
              ],
            ],
          );
        }
        
        // État initial ou autre
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

extension ListTileExtension on ListTile {
  bool get showDivider => this.showDivider;
  set showDivider(bool value) {}
}
