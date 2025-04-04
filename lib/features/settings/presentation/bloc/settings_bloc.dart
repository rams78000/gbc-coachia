import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../domain/entities/settings.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsInitialized extends SettingsEvent {
  const SettingsInitialized();
}

class SettingsThemeModeChanged extends SettingsEvent {
  final ThemeMode themeMode;

  const SettingsThemeModeChanged(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class SettingsLanguageChanged extends SettingsEvent {
  final String language;

  const SettingsLanguageChanged(this.language);

  @override
  List<Object> get props => [language];
}

class SettingsNotificationsToggled extends SettingsEvent {
  final bool enabled;

  const SettingsNotificationsToggled(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class SettingsNotificationPreferencesChanged extends SettingsEvent {
  final NotificationPreferences preferences;

  const SettingsNotificationPreferencesChanged(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class SettingsAIAPIKeySet extends SettingsEvent {
  final String apiKey;

  const SettingsAIAPIKeySet(this.apiKey);

  @override
  List<Object> get props => [apiKey];
}

class SettingsThirdPartyServiceAdded extends SettingsEvent {
  final String name;
  final String key;

  const SettingsThirdPartyServiceAdded(this.name, this.key);

  @override
  List<Object> get props => [name, key];
}

class SettingsPrivacySettingsChanged extends SettingsEvent {
  final PrivacySettings privacySettings;

  const SettingsPrivacySettingsChanged(this.privacySettings);

  @override
  List<Object> get props => [privacySettings];
}

class SettingsUserProfileUpdated extends SettingsEvent {
  final UserProfile profile;

  const SettingsUserProfileUpdated(this.profile);

  @override
  List<Object> get props => [profile];
}

// States
abstract class SettingsState extends Equatable {
  const SettingsState();
  
  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final UserSettings settings;
  final UserProfile profile;

  const SettingsLoaded({
    required this.settings,
    required this.profile,
  });

  @override
  List<Object> get props => [settings, profile];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences _preferences;
  static const String _settingsKey = 'user_settings';
  static const String _profileKey = 'user_profile';

  SettingsBloc({required SharedPreferences preferences}) 
      : _preferences = preferences,
        super(const SettingsInitial()) {
    on<SettingsInitialized>(_onInitialized);
    on<SettingsThemeModeChanged>(_onThemeModeChanged);
    on<SettingsLanguageChanged>(_onLanguageChanged);
    on<SettingsNotificationsToggled>(_onNotificationsToggled);
    on<SettingsNotificationPreferencesChanged>(_onNotificationPreferencesChanged);
    on<SettingsAIAPIKeySet>(_onAIAPIKeySet);
    on<SettingsThirdPartyServiceAdded>(_onThirdPartyServiceAdded);
    on<SettingsPrivacySettingsChanged>(_onPrivacySettingsChanged);
    on<SettingsUserProfileUpdated>(_onUserProfileUpdated);
  }

  Future<void> _onInitialized(
    SettingsInitialized event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    try {
      final settings = _loadSettings();
      final profile = _loadProfile();
      
      emit(SettingsLoaded(
        settings: settings,
        profile: profile,
      ));
    } catch (e) {
      emit(SettingsError('Erreur lors du chargement des paramètres: $e'));
    }
  }

  Future<void> _onThemeModeChanged(
    SettingsThemeModeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final updatedSettings = currentState.settings.copyWith(
        themeMode: event.themeMode,
      );
      
      emit(SettingsLoaded(
        settings: updatedSettings,
        profile: currentState.profile,
      ));
      
      _saveSettings(updatedSettings);
    }
  }

  Future<void> _onLanguageChanged(
    SettingsLanguageChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final updatedSettings = currentState.settings.copyWith(
        language: event.language,
      );
      
      emit(SettingsLoaded(
        settings: updatedSettings,
        profile: currentState.profile,
      ));
      
      _saveSettings(updatedSettings);
    }
  }

  Future<void> _onNotificationsToggled(
    SettingsNotificationsToggled event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final updatedSettings = currentState.settings.copyWith(
        notificationsEnabled: event.enabled,
      );
      
      emit(SettingsLoaded(
        settings: updatedSettings,
        profile: currentState.profile,
      ));
      
      _saveSettings(updatedSettings);
    }
  }

  Future<void> _onNotificationPreferencesChanged(
    SettingsNotificationPreferencesChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final updatedSettings = currentState.settings.copyWith(
        notificationPreferences: event.preferences,
      );
      
      emit(SettingsLoaded(
        settings: updatedSettings,
        profile: currentState.profile,
      ));
      
      _saveSettings(updatedSettings);
    }
  }

  Future<void> _onAIAPIKeySet(
    SettingsAIAPIKeySet event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final updatedApiConfig = currentState.settings.apiConfiguration.copyWith(
        aiApiKey: event.apiKey,
      );
      
      final updatedSettings = currentState.settings.copyWith(
        apiConfiguration: updatedApiConfig,
      );
      
      emit(SettingsLoaded(
        settings: updatedSettings,
        profile: currentState.profile,
      ));
      
      _saveSettings(updatedSettings);
    }
  }

  Future<void> _onThirdPartyServiceAdded(
    SettingsThirdPartyServiceAdded event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      
      final updatedThirdPartyServices = Map<String, String>.from(
        currentState.settings.apiConfiguration.thirdPartyServices,
      );
      updatedThirdPartyServices[event.name] = event.key;
      
      final updatedApiConfig = currentState.settings.apiConfiguration.copyWith(
        thirdPartyServices: updatedThirdPartyServices,
      );
      
      final updatedSettings = currentState.settings.copyWith(
        apiConfiguration: updatedApiConfig,
      );
      
      emit(SettingsLoaded(
        settings: updatedSettings,
        profile: currentState.profile,
      ));
      
      _saveSettings(updatedSettings);
    }
  }

  Future<void> _onPrivacySettingsChanged(
    SettingsPrivacySettingsChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final updatedSettings = currentState.settings.copyWith(
        privacySettings: event.privacySettings,
      );
      
      emit(SettingsLoaded(
        settings: updatedSettings,
        profile: currentState.profile,
      ));
      
      _saveSettings(updatedSettings);
    }
  }

  Future<void> _onUserProfileUpdated(
    SettingsUserProfileUpdated event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      
      emit(SettingsLoaded(
        settings: currentState.settings,
        profile: event.profile,
      ));
      
      _saveProfile(event.profile);
    }
  }

  UserSettings _loadSettings() {
    final settingsJson = _preferences.getString(_settingsKey);
    
    if (settingsJson == null) {
      return UserSettings.defaultSettings();
    }
    
    try {
      final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
      
      // Chargement des préférences de notification
      final notificationPreferencesMap = settingsMap['notificationPreferences'] as Map<String, dynamic>;
      final notificationPreferences = NotificationPreferences(
        invoicesEnabled: notificationPreferencesMap['invoicesEnabled'] as bool,
        tasksEnabled: notificationPreferencesMap['tasksEnabled'] as bool,
        aiTipsEnabled: notificationPreferencesMap['aiTipsEnabled'] as bool,
      );
      
      // Chargement de la configuration API
      final apiConfigMap = settingsMap['apiConfiguration'] as Map<String, dynamic>;
      final thirdPartyServicesMap = apiConfigMap['thirdPartyServices'] as Map<String, dynamic>;
      final thirdPartyServices = thirdPartyServicesMap.map(
        (key, value) => MapEntry(key, value as String),
      );
      
      final apiConfiguration = APIConfiguration(
        aiApiKey: apiConfigMap['aiApiKey'] as String?,
        thirdPartyServices: thirdPartyServices,
      );
      
      // Chargement des paramètres de confidentialité
      final privacySettingsMap = settingsMap['privacySettings'] as Map<String, dynamic>;
      final privacySettings = PrivacySettings(
        dataAnalyticsEnabled: privacySettingsMap['dataAnalyticsEnabled'] as bool,
        autoBackupEnabled: privacySettingsMap['autoBackupEnabled'] as bool,
        activityLoggingEnabled: privacySettingsMap['activityLoggingEnabled'] as bool,
      );
      
      return UserSettings(
        themeMode: ThemeMode.values[settingsMap['themeMode'] as int],
        language: settingsMap['language'] as String,
        notificationsEnabled: settingsMap['notificationsEnabled'] as bool,
        notificationPreferences: notificationPreferences,
        apiConfiguration: apiConfiguration,
        privacySettings: privacySettings,
      );
    } catch (e) {
      // En cas d'erreur, retourner les paramètres par défaut
      return UserSettings.defaultSettings();
    }
  }

  void _saveSettings(UserSettings settings) {
    // Convertir les préférences de notification en map
    final notificationPreferencesMap = {
      'invoicesEnabled': settings.notificationPreferences.invoicesEnabled,
      'tasksEnabled': settings.notificationPreferences.tasksEnabled,
      'aiTipsEnabled': settings.notificationPreferences.aiTipsEnabled,
    };
    
    // Convertir la configuration API en map
    final apiConfigMap = {
      'aiApiKey': settings.apiConfiguration.aiApiKey,
      'thirdPartyServices': settings.apiConfiguration.thirdPartyServices,
    };
    
    // Convertir les paramètres de confidentialité en map
    final privacySettingsMap = {
      'dataAnalyticsEnabled': settings.privacySettings.dataAnalyticsEnabled,
      'autoBackupEnabled': settings.privacySettings.autoBackupEnabled,
      'activityLoggingEnabled': settings.privacySettings.activityLoggingEnabled,
    };
    
    // Créer la map complète des paramètres
    final settingsMap = {
      'themeMode': settings.themeMode.index,
      'language': settings.language,
      'notificationsEnabled': settings.notificationsEnabled,
      'notificationPreferences': notificationPreferencesMap,
      'apiConfiguration': apiConfigMap,
      'privacySettings': privacySettingsMap,
    };
    
    // Sauvegarder en JSON
    final settingsJson = jsonEncode(settingsMap);
    _preferences.setString(_settingsKey, settingsJson);
  }

  UserProfile _loadProfile() {
    final profileJson = _preferences.getString(_profileKey);
    
    if (profileJson == null) {
      return UserProfile.defaultProfile();
    }
    
    try {
      final profileMap = jsonDecode(profileJson) as Map<String, dynamic>;
      
      return UserProfile(
        displayName: profileMap['displayName'] as String,
        email: profileMap['email'] as String,
        isPremium: profileMap['isPremium'] as bool,
        premiumExpiryDate: profileMap['premiumExpiryDate'] != null
            ? DateTime.parse(profileMap['premiumExpiryDate'] as String)
            : null,
        photoUrl: profileMap['photoUrl'] as String?,
      );
    } catch (e) {
      // En cas d'erreur, retourner le profil par défaut
      return UserProfile.defaultProfile();
    }
  }

  void _saveProfile(UserProfile profile) {
    final profileMap = {
      'displayName': profile.displayName,
      'email': profile.email,
      'isPremium': profile.isPremium,
      'premiumExpiryDate': profile.premiumExpiryDate?.toIso8601String(),
      'photoUrl': profile.photoUrl,
    };
    
    final profileJson = jsonEncode(profileMap);
    _preferences.setString(_profileKey, profileJson);
  }
}
