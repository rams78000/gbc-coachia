import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/repositories/settings_repository.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/profile_form.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
        GetIt.instance<SettingsRepository>(),
      )..add(const LoadSettings()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Modifier le profil'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/settings'),
          ),
        ),
        body: const _ProfileSettingsContent(),
      ),
    );
  }
}

class _ProfileSettingsContent extends StatelessWidget {
  const _ProfileSettingsContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${state.message}')),
          );
        } else if (state is SettingsUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil mis à jour avec succès')),
          );
          context.go('/settings');
        }
      },
      builder: (context, state) {
        if (state is SettingsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SettingsLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ProfileForm(
              userProfile: state.userProfile,
              onSubmit: (updatedProfile) {
                context.read<SettingsBloc>().add(
                  UpdateUserProfile(updatedProfile),
                );
              },
              onCancel: () => context.go('/settings'),
            ),
          );
        } else if (state is SettingsUpdating) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Mise à jour du profil...'),
              ],
            ),
          );
        }
        
        // État initial ou autre
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
