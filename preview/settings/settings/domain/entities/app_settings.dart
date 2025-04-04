import 'package:flutter/material.dart';

/// Enum pour le thème de l'application
enum AppTheme {
  light,
  dark,
  system;
  
  /// Affiche le nom du thème
  String get displayName {
    switch (this) {
      case AppTheme.light:
        return 'Mode clair';
      case AppTheme.dark:
        return 'Mode sombre';
      case AppTheme.system:
        return 'Système';
    }
  }
}

/// Enum pour le modèle d'IA
enum AIModel {
  openai,
  deepseek,
  gemini,
  custom;
  
  /// Affiche le nom du modèle
  String get displayName {
    switch (this) {
      case AIModel.openai:
        return 'OpenAI';
      case AIModel.deepseek:
        return 'Deepseek';
      case AIModel.gemini:
        return 'Gemini 2.5 Pro';
      case AIModel.custom:
        return 'Personnalisé';
    }
  }
}

/// Enum pour les préférences de notification
enum NotificationPreference {
  all,
  important,
  none;
  
  /// Affiche le nom de la préférence
  String get displayName {
    switch (this) {
      case NotificationPreference.all:
        return 'Toutes les notifications';
      case NotificationPreference.important:
        return 'Notifications importantes uniquement';
      case NotificationPreference.none:
        return 'Aucune notification';
    }
  }
}

/// Entité représentant les paramètres de l'application
class AppSettings {
  final AppTheme theme;
  final Locale locale;
  final bool useBiometricAuth;
  final NotificationPreference notificationPreference;
  final bool emailNotifications;
  final bool dataCollection;
  final bool crashReporting;
  final AIModel aiModel;
  final Map<AIModel, String> apiKeys;
  final String? customAIEndpoint;
  
  AppSettings({
    this.theme = AppTheme.system,
    this.locale = const Locale('fr', 'FR'),
    this.useBiometricAuth = false,
    this.notificationPreference = NotificationPreference.all,
    this.emailNotifications = true,
    this.dataCollection = true,
    this.crashReporting = true,
    this.aiModel = AIModel.openai,
    this.apiKeys = const {},
    this.customAIEndpoint,
  });
  
  /// Copie les paramètres avec de nouvelles valeurs
  AppSettings copyWith({
    AppTheme? theme,
    Locale? locale,
    bool? useBiometricAuth,
    NotificationPreference? notificationPreference,
    bool? emailNotifications,
    bool? dataCollection,
    bool? crashReporting,
    AIModel? aiModel,
    Map<AIModel, String>? apiKeys,
    String? customAIEndpoint,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      locale: locale ?? this.locale,
      useBiometricAuth: useBiometricAuth ?? this.useBiometricAuth,
      notificationPreference: notificationPreference ?? this.notificationPreference,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      dataCollection: dataCollection ?? this.dataCollection,
      crashReporting: crashReporting ?? this.crashReporting,
      aiModel: aiModel ?? this.aiModel,
      apiKeys: apiKeys ?? this.apiKeys,
      customAIEndpoint: customAIEndpoint ?? this.customAIEndpoint,
    );
  }
  
  /// Obtient l'API key pour un modèle spécifique
  String? getApiKeyForModel(AIModel model) {
    return apiKeys[model];
  }
}
