import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// Énumération pour le thème
enum AppThemeMode {
  light,
  dark,
  system
}

// Énumération pour le niveau de notifications
enum NotificationLevel {
  all,
  important,
  none
}

// Classe principale des paramètres
class AppSettings extends Equatable {
  // Paramètres du thème
  final AppThemeMode themeMode;
  
  // Paramètres des notifications
  final NotificationLevel notificationLevel;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  
  // Paramètres de confidentialité
  final bool analyticsEnabled;
  final bool crashReportingEnabled;
  final bool biometricAuthEnabled;
  
  // Paramètres des API IA
  final String? openAiApiKey;
  final String? deepseekApiKey;
  final String? geminiApiKey;
  final String? customApiUrl;
  final String? customApiKey;
  
  // Paramètres linguistiques
  final Locale locale;

  const AppSettings({
    required this.themeMode,
    required this.notificationLevel,
    required this.pushNotificationsEnabled,
    required this.emailNotificationsEnabled,
    required this.analyticsEnabled,
    required this.crashReportingEnabled,
    required this.biometricAuthEnabled,
    this.openAiApiKey,
    this.deepseekApiKey,
    this.geminiApiKey,
    this.customApiUrl,
    this.customApiKey,
    required this.locale,
  });
  
  // Méthode pour créer une copie modifiée
  AppSettings copyWith({
    AppThemeMode? themeMode,
    NotificationLevel? notificationLevel,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? analyticsEnabled,
    bool? crashReportingEnabled,
    bool? biometricAuthEnabled,
    String? openAiApiKey,
    String? deepseekApiKey,
    String? geminiApiKey,
    String? customApiUrl,
    String? customApiKey,
    Locale? locale,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationLevel: notificationLevel ?? this.notificationLevel,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      crashReportingEnabled: crashReportingEnabled ?? this.crashReportingEnabled,
      biometricAuthEnabled: biometricAuthEnabled ?? this.biometricAuthEnabled,
      openAiApiKey: openAiApiKey ?? this.openAiApiKey,
      deepseekApiKey: deepseekApiKey ?? this.deepseekApiKey,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      customApiUrl: customApiUrl ?? this.customApiUrl,
      customApiKey: customApiKey ?? this.customApiKey,
      locale: locale ?? this.locale,
    );
  }
  
  // Pour Equatable
  @override
  List<Object?> get props => [
    themeMode,
    notificationLevel,
    pushNotificationsEnabled,
    emailNotificationsEnabled,
    analyticsEnabled,
    crashReportingEnabled,
    biometricAuthEnabled,
    openAiApiKey,
    deepseekApiKey,
    geminiApiKey,
    customApiUrl,
    customApiKey,
    locale,
  ];
  
  // Paramètres par défaut
  factory AppSettings.defaultSettings() {
    return const AppSettings(
      themeMode: AppThemeMode.system,
      notificationLevel: NotificationLevel.important,
      pushNotificationsEnabled: true,
      emailNotificationsEnabled: false,
      analyticsEnabled: true,
      crashReportingEnabled: true,
      biometricAuthEnabled: false,
      locale: Locale('fr', 'FR'),
    );
  }
}
