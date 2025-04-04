import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/settings/domain/entities/app_settings.dart';
import 'package:gbc_coachia/features/settings/domain/entities/user_profile.dart';
import 'package:gbc_coachia/features/settings/domain/repositories/settings_repository.dart';

/// Implémentation simulée du repository des paramètres
class MockSettingsRepository implements SettingsRepository {
  // Données simulées
  AppSettings _appSettings = AppSettings(
    theme: AppTheme.system,
    locale: const Locale('fr', 'FR'),
    useBiometricAuth: false,
    notificationPreference: NotificationPreference.all,
    emailNotifications: true,
    dataCollection: true,
    crashReporting: true,
    aiModel: AIModel.openai,
    apiKeys: const {},
  );
  
  UserProfile _userProfile = UserProfile(
    id: 'user123',
    name: 'Jean Dupont',
    email: 'jean.dupont@example.com',
    phoneNumber: '+33 6 12 34 56 78',
    company: 'Entreprise XYZ',
    position: 'Entrepreneur',
    registrationDate: DateTime.now().subtract(const Duration(days: 90)),
    lastLoginDate: DateTime.now(),
  );
  
  @override
  Future<AppSettings> getAppSettings() async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    return _appSettings;
  }
  
  @override
  Future<AppSettings> saveAppSettings(AppSettings settings) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _appSettings = settings;
    return _appSettings;
  }
  
  @override
  Future<UserProfile> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _userProfile;
  }
  
  @override
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _userProfile = profile;
    return _userProfile;
  }
  
  @override
  Future<AppSettings> updateTheme(AppTheme theme) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _appSettings = _appSettings.copyWith(theme: theme);
    return _appSettings;
  }
  
  @override
  Future<AppSettings> updateNotificationPreferences({
    required NotificationPreference preference,
    required bool emailNotifications,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _appSettings = _appSettings.copyWith(
      notificationPreference: preference,
      emailNotifications: emailNotifications,
    );
    return _appSettings;
  }
  
  @override
  Future<AppSettings> updatePrivacySettings({
    required bool dataCollection,
    required bool crashReporting,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _appSettings = _appSettings.copyWith(
      dataCollection: dataCollection,
      crashReporting: crashReporting,
    );
    return _appSettings;
  }
  
  @override
  Future<AppSettings> updateAuthSettings({
    required bool useBiometricAuth,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _appSettings = _appSettings.copyWith(
      useBiometricAuth: useBiometricAuth,
    );
    return _appSettings;
  }
  
  @override
  Future<AppSettings> saveApiKey({
    required AIModel model,
    required String apiKey,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Créer une copie du Map existant et y ajouter la nouvelle clé
    final updatedApiKeys = Map<AIModel, String>.from(_appSettings.apiKeys);
    updatedApiKeys[model] = apiKey;
    
    _appSettings = _appSettings.copyWith(apiKeys: updatedApiKeys);
    return _appSettings;
  }
  
  @override
  Future<AppSettings> saveCustomAIEndpoint(String endpoint) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _appSettings = _appSettings.copyWith(customAIEndpoint: endpoint);
    return _appSettings;
  }
  
  @override
  Future<AppSettings> removeApiKey(AIModel model) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Créer une copie du Map existant et supprimer la clé
    final updatedApiKeys = Map<AIModel, String>.from(_appSettings.apiKeys);
    updatedApiKeys.remove(model);
    
    _appSettings = _appSettings.copyWith(apiKeys: updatedApiKeys);
    return _appSettings;
  }
  
  @override
  Future<AppSettings> updateDefaultAIModel(AIModel model) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _appSettings = _appSettings.copyWith(aiModel: model);
    return _appSettings;
  }
  
  @override
  Future<AppSettings> resetToDefaults() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _appSettings = AppSettings();
    return _appSettings;
  }
  
  @override
  Future<bool> validateApiKey({
    required AIModel model,
    required String apiKey,
    String? endpoint,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Simuler une validation simple (dans une vraie implémentation, cela ferait une requête à l'API)
    if (apiKey.isEmpty) {
      return false;
    }
    
    // Si c'est un modèle personnalisé, vérifier l'endpoint
    if (model == AIModel.custom && (endpoint == null || endpoint.isEmpty)) {
      return false;
    }
    
    return true;
  }
}
