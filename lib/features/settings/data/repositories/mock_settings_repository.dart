import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/settings_repository.dart';

class MockSettingsRepository implements SettingsRepository {
  final SharedPreferences _prefs;
  
  // Clés pour SharedPreferences
  static const String _userProfileKey = 'user_profile';
  static const String _appSettingsKey = 'app_settings';
  
  MockSettingsRepository(this._prefs);
  
  // Implémentation pour le profil utilisateur
  @override
  Future<UserProfile> getUserProfile() async {
    final profileJson = _prefs.getString(_userProfileKey);
    
    if (profileJson != null) {
      final Map<String, dynamic> profileMap = json.decode(profileJson);
      return _userProfileFromMap(profileMap);
    }
    
    // Profil exemple par défaut
    final defaultProfile = UserProfile.example();
    await _saveUserProfile(defaultProfile);
    return defaultProfile;
  }
  
  @override
  Future<void> updateUserProfile(UserProfile userProfile) async {
    await _saveUserProfile(userProfile);
  }
  
  // Implémentation pour les paramètres de l'application
  @override
  Future<AppSettings> getAppSettings() async {
    final settingsJson = _prefs.getString(_appSettingsKey);
    
    if (settingsJson != null) {
      final Map<String, dynamic> settingsMap = json.decode(settingsJson);
      return _appSettingsFromMap(settingsMap);
    }
    
    // Paramètres par défaut
    final defaultSettings = AppSettings.defaultSettings();
    await _saveAppSettings(defaultSettings);
    return defaultSettings;
  }
  
  @override
  Future<void> updateAppSettings(AppSettings appSettings) async {
    await _saveAppSettings(appSettings);
  }
  
  // Implémentations spécifiques pour les paramètres courants
  @override
  Future<void> setThemeMode(AppThemeMode themeMode) async {
    final settings = await getAppSettings();
    final updatedSettings = settings.copyWith(themeMode: themeMode);
    await _saveAppSettings(updatedSettings);
  }
  
  @override
  Future<void> setNotificationLevel(NotificationLevel level) async {
    final settings = await getAppSettings();
    final updatedSettings = settings.copyWith(notificationLevel: level);
    await _saveAppSettings(updatedSettings);
  }
  
  @override
  Future<void> setAnalyticsEnabled(bool enabled) async {
    final settings = await getAppSettings();
    final updatedSettings = settings.copyWith(analyticsEnabled: enabled);
    await _saveAppSettings(updatedSettings);
  }
  
  @override
  Future<void> setCrashReportingEnabled(bool enabled) async {
    final settings = await getAppSettings();
    final updatedSettings = settings.copyWith(crashReportingEnabled: enabled);
    await _saveAppSettings(updatedSettings);
  }
  
  @override
  Future<void> setBiometricAuthEnabled(bool enabled) async {
    final settings = await getAppSettings();
    final updatedSettings = settings.copyWith(biometricAuthEnabled: enabled);
    await _saveAppSettings(updatedSettings);
  }
  
  // Gestion des clés API
  @override
  Future<void> setOpenAiApiKey(String apiKey) async {
    final settings = await getAppSettings();
    final updatedSettings = settings.copyWith(openAiApiKey: apiKey);
    await _saveAppSettings(updatedSettings);
  }
  
  @override
  Future<void> setDeepseekApiKey(String apiKey) async {
    final settings = await getAppSettings();
    final updatedSettings = settings.copyWith(deepseekApiKey: apiKey);
    await _saveAppSettings(updatedSettings);
  }
  
  @override
  Future<void> setGeminiApiKey(String apiKey) async {
    final settings = await getAppSettings();
    final updatedSettings = settings.copyWith(geminiApiKey: apiKey);
    await _saveAppSettings(updatedSettings);
  }
  
  @override
  Future<void> setCustomApiDetails(String apiUrl, String apiKey) async {
    final settings = await getAppSettings();
    final updatedSettings = settings.copyWith(
      customApiUrl: apiUrl,
      customApiKey: apiKey,
    );
    await _saveAppSettings(updatedSettings);
  }
  
  // Nettoyage des données
  @override
  Future<void> clearStoredData() async {
    await _prefs.remove(_userProfileKey);
    await _prefs.remove(_appSettingsKey);
  }
  
  // Méthodes d'aide privées
  
  Future<void> _saveUserProfile(UserProfile profile) async {
    final profileMap = _userProfileToMap(profile);
    await _prefs.setString(_userProfileKey, json.encode(profileMap));
  }
  
  Future<void> _saveAppSettings(AppSettings settings) async {
    final settingsMap = _appSettingsToMap(settings);
    await _prefs.setString(_appSettingsKey, json.encode(settingsMap));
  }
  
  // Conversion Map <-> Object
  
  Map<String, dynamic> _userProfileToMap(UserProfile profile) {
    return {
      'id': profile.id,
      'name': profile.name,
      'email': profile.email,
      'phoneNumber': profile.phoneNumber,
      'companyName': profile.companyName,
      'position': profile.position,
      'address': profile.address,
      'profileImageUrl': profile.profileImageUrl,
      'createdAt': profile.createdAt.toIso8601String(),
      'updatedAt': profile.updatedAt.toIso8601String(),
    };
  }
  
  UserProfile _userProfileFromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      companyName: map['companyName'],
      position: map['position'],
      address: map['address'],
      profileImageUrl: map['profileImageUrl'],
      createdAt: map['createdAt'] != null 
        ? DateTime.parse(map['createdAt']) 
        : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
        ? DateTime.parse(map['updatedAt']) 
        : DateTime.now(),
    );
  }
  
  Map<String, dynamic> _appSettingsToMap(AppSettings settings) {
    return {
      'themeMode': settings.themeMode.index,
      'notificationLevel': settings.notificationLevel.index,
      'pushNotificationsEnabled': settings.pushNotificationsEnabled,
      'emailNotificationsEnabled': settings.emailNotificationsEnabled,
      'analyticsEnabled': settings.analyticsEnabled,
      'crashReportingEnabled': settings.crashReportingEnabled,
      'biometricAuthEnabled': settings.biometricAuthEnabled,
      'openAiApiKey': settings.openAiApiKey,
      'deepseekApiKey': settings.deepseekApiKey,
      'geminiApiKey': settings.geminiApiKey,
      'customApiUrl': settings.customApiUrl,
      'customApiKey': settings.customApiKey,
      'locale': {
        'languageCode': settings.locale.languageCode,
        'countryCode': settings.locale.countryCode,
      },
    };
  }
  
  AppSettings _appSettingsFromMap(Map<String, dynamic> map) {
    final localeMap = map['locale'] as Map<String, dynamic>?;
    
    return AppSettings(
      themeMode: AppThemeMode.values[map['themeMode'] ?? 0],
      notificationLevel: NotificationLevel.values[map['notificationLevel'] ?? 1],
      pushNotificationsEnabled: map['pushNotificationsEnabled'] ?? true,
      emailNotificationsEnabled: map['emailNotificationsEnabled'] ?? false,
      analyticsEnabled: map['analyticsEnabled'] ?? true,
      crashReportingEnabled: map['crashReportingEnabled'] ?? true,
      biometricAuthEnabled: map['biometricAuthEnabled'] ?? false,
      openAiApiKey: map['openAiApiKey'],
      deepseekApiKey: map['deepseekApiKey'],
      geminiApiKey: map['geminiApiKey'],
      customApiUrl: map['customApiUrl'],
      customApiKey: map['customApiKey'],
      locale: localeMap != null 
        ? Locale(
            localeMap['languageCode'] ?? 'fr',
            localeMap['countryCode'] ?? 'FR',
          )
        : const Locale('fr', 'FR'),
    );
  }
}
