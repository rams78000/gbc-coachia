import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserSettings extends Equatable {
  final ThemeMode themeMode;
  final String language;
  final bool notificationsEnabled;
  final NotificationPreferences notificationPreferences;
  final APIConfiguration apiConfiguration;
  final PrivacySettings privacySettings;

  const UserSettings({
    required this.themeMode,
    required this.language,
    required this.notificationsEnabled,
    required this.notificationPreferences,
    required this.apiConfiguration,
    required this.privacySettings,
  });

  factory UserSettings.defaultSettings() {
    return UserSettings(
      themeMode: ThemeMode.light,
      language: 'Français',
      notificationsEnabled: true,
      notificationPreferences: NotificationPreferences.defaultPreferences(),
      apiConfiguration: APIConfiguration.empty(),
      privacySettings: PrivacySettings.defaultSettings(),
    );
  }

  @override
  List<Object> get props => [
    themeMode,
    language,
    notificationsEnabled,
    notificationPreferences,
    apiConfiguration,
    privacySettings,
  ];

  UserSettings copyWith({
    ThemeMode? themeMode,
    String? language,
    bool? notificationsEnabled,
    NotificationPreferences? notificationPreferences,
    APIConfiguration? apiConfiguration,
    PrivacySettings? privacySettings,
  }) {
    return UserSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      apiConfiguration: apiConfiguration ?? this.apiConfiguration,
      privacySettings: privacySettings ?? this.privacySettings,
    );
  }
}

class NotificationPreferences extends Equatable {
  final bool invoicesEnabled;
  final bool tasksEnabled;
  final bool aiTipsEnabled;

  const NotificationPreferences({
    required this.invoicesEnabled,
    required this.tasksEnabled,
    required this.aiTipsEnabled,
  });

  factory NotificationPreferences.defaultPreferences() {
    return const NotificationPreferences(
      invoicesEnabled: true,
      tasksEnabled: true,
      aiTipsEnabled: false,
    );
  }

  @override
  List<Object> get props => [invoicesEnabled, tasksEnabled, aiTipsEnabled];

  NotificationPreferences copyWith({
    bool? invoicesEnabled,
    bool? tasksEnabled,
    bool? aiTipsEnabled,
  }) {
    return NotificationPreferences(
      invoicesEnabled: invoicesEnabled ?? this.invoicesEnabled,
      tasksEnabled: tasksEnabled ?? this.tasksEnabled,
      aiTipsEnabled: aiTipsEnabled ?? this.aiTipsEnabled,
    );
  }
}

class APIConfiguration extends Equatable {
  final String? aiApiKey;
  final Map<String, String> thirdPartyServices;

  const APIConfiguration({
    this.aiApiKey,
    required this.thirdPartyServices,
  });

  factory APIConfiguration.empty() {
    return const APIConfiguration(
      aiApiKey: null,
      thirdPartyServices: {},
    );
  }

  @override
  List<Object?> get props => [aiApiKey, thirdPartyServices];

  APIConfiguration copyWith({
    String? aiApiKey,
    Map<String, String>? thirdPartyServices,
  }) {
    return APIConfiguration(
      aiApiKey: aiApiKey ?? this.aiApiKey,
      thirdPartyServices: thirdPartyServices ?? this.thirdPartyServices,
    );
  }

  bool get hasApiKey => aiApiKey != null && aiApiKey!.isNotEmpty;

  void addThirdPartyService(String name, String key) {
    thirdPartyServices[name] = key;
  }

  void removeThirdPartyService(String name) {
    thirdPartyServices.remove(name);
  }
}

class PrivacySettings extends Equatable {
  final bool dataAnalyticsEnabled;
  final bool autoBackupEnabled;
  final bool activityLoggingEnabled;

  const PrivacySettings({
    required this.dataAnalyticsEnabled,
    required this.autoBackupEnabled,
    required this.activityLoggingEnabled,
  });

  factory PrivacySettings.defaultSettings() {
    return const PrivacySettings(
      dataAnalyticsEnabled: true,
      autoBackupEnabled: true,
      activityLoggingEnabled: true,
    );
  }

  @override
  List<Object> get props => [
    dataAnalyticsEnabled,
    autoBackupEnabled,
    activityLoggingEnabled,
  ];

  PrivacySettings copyWith({
    bool? dataAnalyticsEnabled,
    bool? autoBackupEnabled,
    bool? activityLoggingEnabled,
  }) {
    return PrivacySettings(
      dataAnalyticsEnabled: dataAnalyticsEnabled ?? this.dataAnalyticsEnabled,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      activityLoggingEnabled: activityLoggingEnabled ?? this.activityLoggingEnabled,
    );
  }
}

class UserProfile extends Equatable {
  final String displayName;
  final String email;
  final bool isPremium;
  final DateTime? premiumExpiryDate;
  final String? photoUrl;

  const UserProfile({
    required this.displayName,
    required this.email,
    required this.isPremium,
    this.premiumExpiryDate,
    this.photoUrl,
  });

  factory UserProfile.defaultProfile() {
    return const UserProfile(
      displayName: 'Entrepreneur Pro',
      email: 'entrepreneur@example.com',
      isPremium: true,
      premiumExpiryDate: null,
      photoUrl: null,
    );
  }

  @override
  List<Object?> get props => [
    displayName,
    email,
    isPremium,
    premiumExpiryDate,
    photoUrl,
  ];

  UserProfile copyWith({
    String? displayName,
    String? email,
    bool? isPremium,
    DateTime? premiumExpiryDate,
    String? photoUrl,
  }) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
