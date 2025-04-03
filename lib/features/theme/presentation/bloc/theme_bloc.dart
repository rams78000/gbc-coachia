import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme Event
abstract class ThemeEvent extends Equatable {
  /// Constructor
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Change theme event
class ThemeChanged extends ThemeEvent {
  /// Constructor
  const ThemeChanged(this.themeMode);

  /// Theme mode
  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];
}

/// Load theme event
class ThemeLoaded extends ThemeEvent {
  /// Constructor
  const ThemeLoaded();
}

/// Theme State
class ThemeState extends Equatable {
  /// Constructor
  const ThemeState({required this.themeMode});

  /// Theme mode
  final ThemeMode themeMode;

  /// Initial state
  factory ThemeState.initial() => const ThemeState(themeMode: ThemeMode.system);

  /// Copy with
  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [themeMode];
}

/// Theme Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  /// Constructor
  ThemeBloc() : super(ThemeState.initial()) {
    on<ThemeChanged>(_onThemeChanged);
    on<ThemeLoaded>(_onThemeLoaded);
  }

  /// Theme storage key
  static const String themeKey = 'app_theme_mode';

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeKey, event.themeMode.index);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  Future<void> _onThemeLoaded(
    ThemeLoaded event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(themeKey);
    if (themeIndex != null) {
      final themeMode = ThemeMode.values[themeIndex];
      emit(state.copyWith(themeMode: themeMode));
    }
  }
}
