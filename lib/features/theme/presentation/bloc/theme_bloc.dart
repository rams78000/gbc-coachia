import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// Theme event
abstract class ThemeEvent extends Equatable {
  /// Constructor
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Theme change event
class ThemeChanged extends ThemeEvent {
  /// Constructor
  const ThemeChanged(this.themeMode);

  /// Theme mode
  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];
}

/// Theme state
class ThemeState extends Equatable {
  /// Constructor
  const ThemeState({required this.themeMode});

  /// Theme mode
  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];

  /// Copy with
  ThemeState copyWith({
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

/// Theme bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  /// Constructor
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.light)) {
    on<ThemeChanged>(_onThemeChanged);
  }

  void _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(themeMode: event.themeMode));
  }
}
