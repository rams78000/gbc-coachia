import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/settings/domain/entities/user_profile.dart';
import 'package:gbc_coachia/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:gbc_coachia/features/settings/presentation/widgets/profile_form.dart';

/// Page des paramètres de profil
class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);
  
  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(LoadUserProfile());
  }
  
  void _openEditProfileDialog(UserProfile profile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: ProfileForm(initialProfile: profile),
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          UserProfile? profile;
          if (state is UserProfileLoaded) {
            profile = state.profile;
          } else if (state is UserProfileUpdated) {
            profile = state.profile;
          }
          
          if (profile == null) {
            return const Center(
              child: Text('Chargement du profil...'),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo de profil
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                        backgroundImage: profile.profilePictureUrl != null
                            ? NetworkImage(profile.profilePictureUrl!)
                            : null,
                        child: profile.profilePictureUrl == null
                            ? Text(
                                profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                                style: theme.textTheme.displaySmall,
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.name,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.email,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                const Divider(),
                
                // Informations du profil
                _buildProfileInfoSection(profile, theme),
                
                const SizedBox(height: 32),
                
                // Bouton d'édition
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _openEditProfileDialog(profile),
                    icon: const Icon(Icons.edit),
                    label: const Text('Modifier le profil'),
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildProfileInfoSection(UserProfile profile, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        
        _buildInfoItem(
          icon: Icons.phone,
          title: 'Téléphone',
          value: profile.phoneNumber ?? 'Non renseigné',
          theme: theme,
        ),
        const Divider(height: 32),
        
        _buildInfoItem(
          icon: Icons.business,
          title: 'Entreprise',
          value: profile.company ?? 'Non renseigné',
          theme: theme,
        ),
        const Divider(height: 32),
        
        _buildInfoItem(
          icon: Icons.work,
          title: 'Poste',
          value: profile.position ?? 'Non renseigné',
          theme: theme,
        ),
        const Divider(height: 32),
        
        _buildInfoItem(
          icon: Icons.location_on,
          title: 'Adresse',
          value: profile.address ?? 'Non renseigné',
          theme: theme,
        ),
        const Divider(height: 32),
        
        _buildInfoItem(
          icon: Icons.calendar_today,
          title: 'Date d\'inscription',
          value: '${profile.registrationDate.day}/${profile.registrationDate.month}/${profile.registrationDate.year}',
          theme: theme,
        ),
        if (profile.lastLoginDate != null) ...[
          const Divider(height: 32),
          _buildInfoItem(
            icon: Icons.login,
            title: 'Dernière connexion',
            value: '${profile.lastLoginDate!.day}/${profile.lastLoginDate!.month}/${profile.lastLoginDate!.year}',
            theme: theme,
          ),
        ],
      ],
    );
  }
  
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 24,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
