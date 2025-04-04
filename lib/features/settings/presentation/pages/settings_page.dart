import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../onboarding/presentation/bloc/onboarding_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Section du profil
            ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  color: primaryColor,
                ),
              ),
              title: const Text('Profil utilisateur'),
              subtitle: const Text('Modifier vos informations personnelles'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigation vers la page de profil
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir : édition du profil'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            const Divider(),
            
            // Section Apparence
            const ListTile(
              title: Text(
                'Apparence',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            SwitchListTile(
              title: const Text('Mode sombre'),
              subtitle: const Text('Activer le thème sombre'),
              value: false, // À connecter au state manager pour le thème
              onChanged: (value) {
                // Changer le thème
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir : changement de thème'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              secondary: Icon(
                Icons.dark_mode,
                color: primaryColor,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.language,
                color: primaryColor,
              ),
              title: const Text('Langue'),
              subtitle: const Text('Français'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Changer la langue
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir : changement de langue'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            const Divider(),
            
            // Section Notifications
            const ListTile(
              title: Text(
                'Notifications',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            SwitchListTile(
              title: const Text('Notifications Push'),
              subtitle: const Text('Recevoir des alertes sur votre appareil'),
              value: true, // À connecter au state manager pour les notifications
              onChanged: (value) {
                // Activer/désactiver les notifications
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir : gestion des notifications'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              secondary: Icon(
                Icons.notifications,
                color: primaryColor,
              ),
            ),
            SwitchListTile(
              title: const Text('Emails'),
              subtitle: const Text('Recevoir des rapports par email'),
              value: true, // À connecter au state manager pour les emails
              onChanged: (value) {
                // Activer/désactiver les emails
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir : gestion des emails'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              secondary: Icon(
                Icons.email,
                color: primaryColor,
              ),
            ),
            const Divider(),
            
            // Section Sécurité
            const ListTile(
              title: Text(
                'Sécurité',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.lock,
                color: primaryColor,
              ),
              title: const Text('Changer le mot de passe'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Changer le mot de passe
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir : changement de mot de passe'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text('Authentification biométrique'),
              subtitle: const Text('Utiliser votre empreinte ou visage'),
              value: false, // À connecter au state manager pour la biométrie
              onChanged: (value) {
                // Activer/désactiver la biométrie
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir : authentification biométrique'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              secondary: Icon(
                Icons.fingerprint,
                color: primaryColor,
              ),
            ),
            const Divider(),
            
            // Section Support
            const ListTile(
              title: Text(
                'Support',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.help,
                color: primaryColor,
              ),
              title: const Text('Centre d\'aide'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Ouvrir le centre d'aide
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir : centre d\'aide'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.feedback,
                color: primaryColor,
              ),
              title: const Text('Envoyer des commentaires'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Envoyer des commentaires
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir : envoi de commentaires'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            const Divider(),
            
            // Section Avancée
            const ListTile(
              title: Text(
                'Avancé',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Effacer les données'),
              subtitle: const Text('Supprimer toutes vos données de l\'application'),
              onTap: () {
                // Demander confirmation puis effacer les données
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Effacer les données?'),
                    content: const Text(
                      'Cette action supprimera toutes vos données et est irréversible. Voulez-vous continuer?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Effacer les données
                          context.read<OnboardingBloc>().add(const OnboardingReset());
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Données effacées avec succès'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text(
                          'Effacer',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text('Déconnexion'),
              onTap: () {
                // Déconnexion
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Déconnexion'),
                    content: const Text('Êtes-vous sûr de vouloir vous déconnecter?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<AuthBloc>().add(const AuthLoggedOut());
                        },
                        child: const Text('Déconnexion'),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 40),
            
            // Version de l'application
            const Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '© 2025 GBC CoachIA',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
