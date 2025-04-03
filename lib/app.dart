import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gbc_coachia/config/router/app_router.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gbc_coachia/features/theme/presentation/bloc/theme_bloc.dart';

/// Main application widget
class GBCCoachIAApp extends StatelessWidget {
  /// Create a GBCCoachIAApp
  const GBCCoachIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => GetIt.instance<AuthBloc>()
            ..add(const AuthCheckRequested()),
        ),
        BlocProvider<ThemeBloc>(
          create: (_) => GetIt.instance<ThemeBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'GBC CoachIA',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            routerConfig: AppRouter.getRouter(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
