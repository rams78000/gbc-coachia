import '../entities/app_settings.dart';
import '../entities/user_profile.dart';

abstract class SettingsRepository {
  // Profil utilisateur
  Future<UserProfile> getUserProfile();
  Future<void> updateUserProfile(UserProfile userProfile);
  
  // Paramètres de l'application
  Future<AppSettings> getAppSettings();
  Future<void> updateAppSettings(AppSettings appSettings);
  
  // Méthodes spécifiques pour les paramètres courants
  Future<void> setThemeMode(AppThemeMode themeMode);
  Future<void> setNotificationLevel(NotificationLevel level);
  Future<void> setAnalyticsEnabled(bool enabled);
  Future<void> setCrashReportingEnabled(bool enabled);
  Future<void> setBiometricAuthEnabled(bool enabled);
  
  // Gestion des clés API
  Future<void> setOpenAiApiKey(String apiKey);
  Future<void> setDeepseekApiKey(String apiKey);
  Future<void> setGeminiApiKey(String apiKey);
  Future<void> setCustomApiDetails(String apiUrl, String apiKey);
  
  // Nettoyage des données
  Future<void> clearStoredData();
}
