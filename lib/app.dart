import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/config/router/app_router.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gbc_coachia/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:get_it/get_it.dart';

/// The main app widget
class GBCCoachIAApp extends StatelessWidget {
  const GBCCoachIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => GetIt.I<ThemeBloc>()..add(ThemeInitialized()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => GetIt.I<AuthBloc>()..add(AuthCheckRequested()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'GBC CoachIA',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}