import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/settings_repository.dart';

// Événements
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class UpdateUserProfile extends SettingsEvent {
  final UserProfile updatedProfile;
  
  const UpdateUserProfile(this.updatedProfile);
  
  @override
  List<Object> get props => [updatedProfile];
}

class UpdateThemeMode extends SettingsEvent {
  final AppThemeMode themeMode;
  
  const UpdateThemeMode(this.themeMode);
  
  @override
  List<Object> get props => [themeMode];
}

class UpdateNotificationLevel extends SettingsEvent {
  final NotificationLevel level;
  
  const UpdateNotificationLevel(this.level);
  
  @override
  List<Object> get props => [level];
}

class UpdatePushNotifications extends SettingsEvent {
  final bool enabled;
  
  const UpdatePushNotifications(this.enabled);
  
  @override
  List<Object> get props => [enabled];
}

class UpdateEmailNotifications extends SettingsEvent {
  final bool enabled;
  
  const UpdateEmailNotifications(this.enabled);
  
  @override
  List<Object> get props => [enabled];
}

class UpdateAnalytics extends SettingsEvent {
  final bool enabled;
  
  const UpdateAnalytics(this.enabled);
  
  @override
  List<Object> get props => [enabled];
}

class UpdateCrashReporting extends SettingsEvent {
  final bool enabled;
  
  const UpdateCrashReporting(this.enabled);
  
  @override
  List<Object> get props => [enabled];
}

class UpdateBiometricAuth extends SettingsEvent {
  final bool enabled;
  
  const UpdateBiometricAuth(this.enabled);
  
  @override
  List<Object> get props => [enabled];
}

class UpdateOpenAiApiKey extends SettingsEvent {
  final String apiKey;
  
  const UpdateOpenAiApiKey(this.apiKey);
  
  @override
  List<Object> get props => [apiKey];
}

class UpdateDeepseekApiKey extends SettingsEvent {
  final String apiKey;
  
  const UpdateDeepseekApiKey(this.apiKey);
  
  @override
  List<Object> get props => [apiKey];
}

class UpdateGeminiApiKey extends SettingsEvent {
  final String apiKey;
  
  const UpdateGeminiApiKey(this.apiKey);
  
  @override
  List<Object> get props => [apiKey];
}

class UpdateCustomApiDetails extends SettingsEvent {
  final String apiUrl;
  final String apiKey;
  
  const UpdateCustomApiDetails({
    required this.apiUrl,
    required this.apiKey,
  });
  
  @override
  List<Object> get props => [apiUrl, apiKey];
}

class ClearAllSettings extends SettingsEvent {
  const ClearAllSettings();
}

// États
abstract class SettingsState extends Equatable {
  const SettingsState();
  
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final UserProfile userProfile;
  final AppSettings appSettings;
  
  const SettingsLoaded({
    required this.userProfile,
    required this.appSettings,
  });
  
  @override
  List<Object> get props => [userProfile, appSettings];
  
  SettingsLoaded copyWith({
    UserProfile? userProfile,
    AppSettings? appSettings,
  }) {
    return SettingsLoaded(
      userProfile: userProfile ?? this.userProfile,
      appSettings: appSettings ?? this.appSettings,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;
  
  const SettingsError(this.message);
  
  @override
  List<Object> get props => [message];
}

class SettingsUpdating extends SettingsState {
  const SettingsUpdating();
}

class SettingsUpdateSuccess extends SettingsState {
  const SettingsUpdateSuccess();
}

// BLoC
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;
  
  SettingsBloc(this._repository) : super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UpdateThemeMode>(_onUpdateThemeMode);
    on<UpdateNotificationLevel>(_onUpdateNotificationLevel);
    on<UpdatePushNotifications>(_onUpdatePushNotifications);
    on<UpdateEmailNotifications>(_onUpdateEmailNotifications);
    on<UpdateAnalytics>(_onUpdateAnalytics);
    on<UpdateCrashReporting>(_onUpdateCrashReporting);
    on<UpdateBiometricAuth>(_onUpdateBiometricAuth);
    on<UpdateOpenAiApiKey>(_onUpdateOpenAiApiKey);
    on<UpdateDeepseekApiKey>(_onUpdateDeepseekApiKey);
    on<UpdateGeminiApiKey>(_onUpdateGeminiApiKey);
    on<UpdateCustomApiDetails>(_onUpdateCustomApiDetails);
    on<ClearAllSettings>(_onClearAllSettings);
  }
  
  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());
    try {
      final userProfile = await _repository.getUserProfile();
      final appSettings = await _repository.getAppSettings();
      emit(SettingsLoaded(
        userProfile: userProfile,
        appSettings: appSettings,
      ));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
  
  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(const SettingsUpdating());
      try {
        await _repository.updateUserProfile(event.updatedProfile);
        emit(currentState.copyWith(userProfile: event.updatedProfile));
      } catch (e) {
        emit(SettingsError(e.toString()));
        emit(currentState); // Revenir à l'état précédent
      }
    }
  }
  
  Future<void> _onUpdateThemeMode(
    UpdateThemeMode event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(const SettingsUpdating());
      try {
        await _repository.setThemeMode(event.themeMode);
        final updatedSettings = currentState.appSettings.copyWith(
          themeMode: event.themeMode,
        );
        emit(currentState.copyWith(appSettings: updatedSettings));
      } catch (e) {
        emit(SettingsError(e.toString()));
        emit(currentState); // Revenir à l'état précédent
      }
    }
  }
  
  Future<void> _onUpdateNotificationLevel(
    UpdateNotificationLevel event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(const SettingsUpdating());
      try {
        await _repository.setNotificationLevel(event.level);
        final updatedSettings = currentState.appSettings.copyWith(
          notificationLevel: event.level,
        );
        emit(currentState.copyWith(appSettings: updatedSettings));
      } catch (e) {
        emit(SettingsError(e.toString()));
        emit(currentState);
      }
    }
  }
  
  Future<void> _onUpdatePushNotifications(
    UpdatePushNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(const SettingsUpdating());
      try {
        final updatedSettings = currentState.appSettings.copyWith(
          pushNotificationsEnabled: event.enabled,
        );
        await _repository.updateAppSettings(updatedSettings);
        emit(currentState.copyWith(appSettings: updatedSettings));
      } catch (e) {
        emit(SettingsError(e.toString()));
        emit(currentState);
      }
    }
  }
  
  Future<void> _onUpdateEmailNotifications(
    UpdateEmailNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(const SettingsUpdating());
      try {
        final updatedSettings = currentState.appSettings.copyWith(
          emailNotificationsEnabled: event.enabled,
        );
        await _repository.updateAppSettings(updatedSettings);
        emit(currentState.copyWith(appSettings: updatedSettings));
      } catch (e) {
        emit(SettingsError(e.toString()));
        emit(currentState);
      }
    }
  }
  
  Future<void> _onUpdateAnalytics(
    UpdateAnalytics event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(const SettingsUpdating());
      try {
        await _repository.setAnalyticsEnabled(event.enabled);
        final updatedSettings = currentState.appSettings.copyWith(
          analyticsEnabled: event.enabled,
        );
        emit(currentState.copyWith(appSettings: updatedSettings));
      } catch (e) {
        emit(SettingsError(e.toString()));
        emit(currentState);
      }
    }
  }
  
  Future<void> _onUpdateCrashReporting(
    UpdateCrashReporting event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(const SettingsUpdating());
      try {
        await _repository.setCrashReportingEnabled(event.enabled);
        final updatedSettings = currentState.appSettings.copyWith(
          crashReportingEnabled: event.enabled,
        );
        emit(currentState.copyWith(appSettings: updatedSettings));
      } catch (e) {
        emit(SettingsError(e.toString()));
        emit(currentState);
      }
    }
  }
  
  Future<void> _onUpdateBiometricAuth(
    UpdateBiometricAuth event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(const SettingsUpdating());
      try {
        await _repository.setBiometricAuthEnabled(event.enabled);
        final updatedSettings = currentState.appSettings.copyWith(
          biometricAuthEnabled: event.enabled,
        );
        emit(currentState.copyWith(appSettings: updatedSettings));
      } catch (e) {
        emit(SettingsError(e.toString()));
        emit(currentState);
      }
    }
  }
  
  Future<void> _onUpdateOpenAiApiKey(
    UpdateOpenAiApiKey event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(const SettingsUpdating());
      try {
        await _repository.setOpenAiApiKey(event.apiKey);
        final updatedSettings = currentState.appSettings.copyWith(
          openAiApiKey: event.apiKey,
        );
        emit(currentState.copyWith(appSettings: updatedSettings));
      } catch (e) {
        emit(SettingsError(e.toString()));
        emit(currentState);
      }
    }
  }
  
  Future<void> _onUpdateDeepseekApiKey(
    UpdateDeepseekApiKey event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(const SettingsUpdating());
      try {
        await _repository.setDeepseekApiKey(event.apiKey);
        final updatedSettings = currentState.appSettings.copyWith(
          deepseekApiKey: event.apiKey,
        );
        emit(currentState.copyWith(appSettings: updatedSettings));
      } catch (e) {
        emit(SettingsError(e.toString()));
        emit(currentState);
      }
    }
  }
  
  Future<void> _onUpdateGeminiApiKey(
    UpdateGeminiApiKey event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(const SettingsUpdating());
      try {
        await _repository.setGeminiApiKey(event.apiKey);
        final updatedSettings = currentState.appSettings.copyWith(
          geminiApiKey: event.apiKey,
        );
        emit(currentState.copyWith(appSettings: updatedSettings));
      } catch (e) {
        emit(SettingsError(e.toString()));
        emit(currentState);
      }
    }
  }
  
  Future<void> _onUpdateCustomApiDetails(
    UpdateCustomApiDetails event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(const SettingsUpdating());
      try {
        await _repository.setCustomApiDetails(event.apiUrl, event.apiKey);
        final updatedSettings = currentState.appSettings.copyWith(
          customApiUrl: event.apiUrl,
          customApiKey: event.apiKey,
        );
        emit(currentState.copyWith(appSettings: updatedSettings));
      } catch (e) {
        emit(SettingsError(e.toString()));
        emit(currentState);
      }
    }
  }
  
  Future<void> _onClearAllSettings(
    ClearAllSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsUpdating());
    try {
      await _repository.clearStoredData();
      // Recharger les paramètres par défaut
      add(const LoadSettings());
    } catch (e) {
      emit(SettingsError(e.toString()));
      // Tenter de recharger les paramètres existants
      add(const LoadSettings());
    }
  }
}
