import 'package:flutter/material.dart';

class ConfigurationStepContent extends StatefulWidget {
  final Function(Map<String, dynamic>) onPreferencesSaved;

  const ConfigurationStepContent({
    Key? key,
    required this.onPreferencesSaved,
  }) : super(key: key);

  @override
  State<ConfigurationStepContent> createState() => _ConfigurationStepContentState();
}

class _ConfigurationStepContentState extends State<ConfigurationStepContent> {
  bool receiveNotifications = true;
  String selectedTheme = 'system';
  String selectedLanguage = 'french';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personnalisez votre expérience',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFB87333),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Thème
            Text(
              'Thème de l\'application',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildThemeSelector(),
            const SizedBox(height: 24),
            
            // Langue
            Text(
              'Langue préférée',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildLanguageSelector(),
            const SizedBox(height: 24),
            
            // Notifications
            _buildNotificationToggle(),
            const SizedBox(height: 36),
            
            // Sauvegarder les préférences
            Center(
              child: ElevatedButton(
                onPressed: _savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB87333),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Enregistrer mes préférences'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildThemeOption('Clair', 'light'),
          const Divider(height: 1),
          _buildThemeOption('Sombre', 'dark'),
          const Divider(height: 1),
          _buildThemeOption('Système', 'system'),
        ],
      ),
    );
  }

  Widget _buildThemeOption(String label, String value) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: selectedTheme,
      activeColor: const Color(0xFFB87333),
      onChanged: (newValue) {
        setState(() {
          selectedTheme = newValue!;
        });
      },
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLanguageOption('Français', 'french'),
          const Divider(height: 1),
          _buildLanguageOption('English', 'english'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String label, String value) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: selectedLanguage,
      activeColor: const Color(0xFFB87333),
      onChanged: (newValue) {
        setState(() {
          selectedLanguage = newValue!;
        });
      },
    );
  }

  Widget _buildNotificationToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Text(
          'Activer les notifications',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: const Text(
          'Recevez des alertes et rappels pour optimiser votre activité',
        ),
        value: receiveNotifications,
        activeColor: const Color(0xFFB87333),
        onChanged: (value) {
          setState(() {
            receiveNotifications = value;
          });
        },
      ),
    );
  }

  void _savePreferences() {
    final preferences = {
      'theme': selectedTheme,
      'language': selectedLanguage,
      'notifications_enabled': receiveNotifications,
    };
    
    widget.onPreferencesSaved(preferences);
  }
}
