import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/settings/domain/entities/app_settings.dart';
import 'package:gbc_coachia/features/settings/domain/entities/user_profile.dart';
import 'package:gbc_coachia/features/settings/domain/repositories/settings_repository.dart';

// Events
abstract class SettingsEvent {}

/// Événement pour charger les paramètres
class LoadSettings extends SettingsEvent {}

/// Événement pour charger le profil utilisateur
class LoadUserProfile extends SettingsEvent {}

/// Événement pour mettre à jour le thème
class UpdateTheme extends SettingsEvent {
  final AppTheme theme;
  
  UpdateTheme(this.theme);
}

/// Événement pour mettre à jour les préférences de notification
class UpdateNotificationPreferences extends SettingsEvent {
  final NotificationPreference preference;
  final bool emailNotifications;
  
  UpdateNotificationPreferences({
    required this.preference,
    required this.emailNotifications,
  });
}

/// Événement pour mettre à jour les paramètres de confidentialité
class UpdatePrivacySettings extends SettingsEvent {
  final bool dataCollection;
  final bool crashReporting;
  
  UpdatePrivacySettings({
    required this.dataCollection,
    required this.crashReporting,
  });
}

/// Événement pour mettre à jour les paramètres d'authentification
class UpdateAuthSettings extends SettingsEvent {
  final bool useBiometricAuth;
  
  UpdateAuthSettings({required this.useBiometricAuth});
}

/// Événement pour sauvegarder une clé API
class SaveApiKey extends SettingsEvent {
  final AIModel model;
  final String apiKey;
  
  SaveApiKey({required this.model, required this.apiKey});
}

/// Événement pour sauvegarder un endpoint personnalisé
class SaveCustomAIEndpoint extends SettingsEvent {
  final String endpoint;
  
  SaveCustomAIEndpoint(this.endpoint);
}

/// Événement pour supprimer une clé API
class RemoveApiKey extends SettingsEvent {
  final AIModel model;
  
  RemoveApiKey(this.model);
}

/// Événement pour valider une clé API
class ValidateApiKey extends SettingsEvent {
  final AIModel model;
  final String apiKey;
  final String? endpoint;
  
  ValidateApiKey({
    required this.model,
    required this.apiKey,
    this.endpoint,
  });
}

/// Événement pour mettre à jour le modèle d'IA par défaut
class UpdateDefaultAIModel extends SettingsEvent {
  final AIModel model;
  
  UpdateDefaultAIModel(this.model);
}

/// Événement pour réinitialiser les paramètres
class ResetSettings extends SettingsEvent {}

/// Événement pour mettre à jour le profil utilisateur
class UpdateUserProfile extends SettingsEvent {
  final UserProfile profile;
  
  UpdateUserProfile(this.profile);
}

// States
abstract class SettingsState {}

/// État initial
class SettingsInitial extends SettingsState {}

/// État de chargement
class SettingsLoading extends SettingsState {}

/// État lorsque les paramètres sont chargés
class SettingsLoaded extends SettingsState {
  final AppSettings settings;
  
  SettingsLoaded(this.settings);
}

/// État lorsque le profil est chargé
class UserProfileLoaded extends SettingsState {
  final UserProfile profile;
  
  UserProfileLoaded(this.profile);
}

/// État lorsque le profil est mis à jour
class UserProfileUpdated extends SettingsState {
  final UserProfile profile;
  
  UserProfileUpdated(this.profile);
}

/// État lorsque la clé API est validée
class ApiKeyValidated extends SettingsState {
  final bool isValid;
  final AIModel model;
  
  ApiKeyValidated({required this.isValid, required this.model});
}

/// État d'erreur
class SettingsError extends SettingsState {
  final String message;
  
  SettingsError(this.message);
}

/// État lorsque les paramètres sont mis à jour
class SettingsUpdated extends SettingsState {
  final AppSettings settings;
  
  SettingsUpdated(this.settings);
}

/// Bloc pour gérer les paramètres
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;
  
  SettingsBloc({required this.repository}) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateTheme>(_onUpdateTheme);
    on<UpdateNotificationPreferences>(_onUpdateNotificationPreferences);
    on<UpdatePrivacySettings>(_onUpdatePrivacySettings);
    on<UpdateAuthSettings>(_onUpdateAuthSettings);
    on<SaveApiKey>(_onSaveApiKey);
    on<SaveCustomAIEndpoint>(_onSaveCustomAIEndpoint);
    on<RemoveApiKey>(_onRemoveApiKey);
    on<ValidateApiKey>(_onValidateApiKey);
    on<UpdateDefaultAIModel>(_onUpdateDefaultAIModel);
    on<ResetSettings>(_onResetSettings);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }
  
  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final settings = await repository.getAppSettings();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
  
  void _onLoadUserProfile(LoadUserProfile event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final profile = await repository.getUserProfile();
      emit(UserProfileLoaded(profile));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
  
  void _onUpdateTheme(UpdateTheme event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final updatedSettings = await repository.updateTheme(event.theme);
      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
  
  void _onUpdateNotificationPreferences(
    UpdateNotificationPreferences event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final updatedSettings = await repository.updateNotificationPreferences(
        preference: event.preference,
        emailNotifications: event.emailNotifications,
      );
      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
  
  void _onUpdatePrivacySettings(
    UpdatePrivacySettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final updatedSettings = await repository.updatePrivacySettings(
        dataCollection: event.dataCollection,
        crashReporting: event.crashReporting,
      );
      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
  
  void _onUpdateAuthSettings(
    UpdateAuthSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final updatedSettings = await repository.updateAuthSettings(
        useBiometricAuth: event.useBiometricAuth,
      );
      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
  
  void _onSaveApiKey(SaveApiKey event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final updatedSettings = await repository.saveApiKey(
        model: event.model,
        apiKey: event.apiKey,
      );
      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
  
  void _onSaveCustomAIEndpoint(
    SaveCustomAIEndpoint event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final updatedSettings = await repository.saveCustomAIEndpoint(event.endpoint);
      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
  
  void _onRemoveApiKey(RemoveApiKey event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final updatedSettings = await repository.removeApiKey(event.model);
      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
  
  void _onValidateApiKey(ValidateApiKey event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final isValid = await repository.validateApiKey(
        model: event.model,
        apiKey: event.apiKey,
        endpoint: event.endpoint,
      );
      emit(ApiKeyValidated(isValid: isValid, model: event.model));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
  
  void _onUpdateDefaultAIModel(
    UpdateDefaultAIModel event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final updatedSettings = await repository.updateDefaultAIModel(event.model);
      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
  
  void _onResetSettings(ResetSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final updatedSettings = await repository.resetToDefaults();
      emit(SettingsUpdated(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
  
  void _onUpdateUserProfile(UpdateUserProfile event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final updatedProfile = await repository.updateUserProfile(event.profile);
      emit(UserProfileUpdated(updatedProfile));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
