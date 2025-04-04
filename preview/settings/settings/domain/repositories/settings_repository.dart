import 'package:gbc_coachia/features/settings/domain/entities/app_settings.dart';
import 'package:gbc_coachia/features/settings/domain/entities/user_profile.dart';

/// Contrat pour le repository des paramètres
abstract class SettingsRepository {
  /// Récupère les paramètres de l'application
  Future<AppSettings> getAppSettings();
  
  /// Enregistre les paramètres de l'application
  Future<AppSettings> saveAppSettings(AppSettings settings);
  
  /// Récupère le profil de l'utilisateur
  Future<UserProfile> getUserProfile();
  
  /// Met à jour le profil de l'utilisateur
  Future<UserProfile> updateUserProfile(UserProfile profile);
  
  /// Met à jour le thème de l'application
  Future<AppSettings> updateTheme(AppTheme theme);
  
  /// Met à jour les préférences de notification
  Future<AppSettings> updateNotificationPreferences({
    required NotificationPreference preference,
    required bool emailNotifications,
  });
  
  /// Met à jour la configuration de confidentialité
  Future<AppSettings> updatePrivacySettings({
    required bool dataCollection,
    required bool crashReporting,
  });
  
  /// Met à jour les paramètres d'authentification
  Future<AppSettings> updateAuthSettings({
    required bool useBiometricAuth,
  });
  
  /// Enregistre une clé API pour un modèle d'IA
  Future<AppSettings> saveApiKey({
    required AIModel model,
    required String apiKey,
  });
  
  /// Enregistre un endpoint personnalisé pour l'IA
  Future<AppSettings> saveCustomAIEndpoint(String endpoint);
  
  /// Supprime une clé API
  Future<AppSettings> removeApiKey(AIModel model);
  
  /// Met à jour le modèle d'IA par défaut
  Future<AppSettings> updateDefaultAIModel(AIModel model);
  
  /// Réinitialise tous les paramètres aux valeurs par défaut
  Future<AppSettings> resetToDefaults();
  
  /// Vérifie si une clé API est valide
  Future<bool> validateApiKey({
    required AIModel model,
    required String apiKey,
    String? endpoint,
  });
}
