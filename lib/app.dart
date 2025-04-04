import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/config/di/service_locator.dart';
import 'package:gbc_coachia/config/router/app_router.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';
import 'package:gbc_coachia/features/auth/domain/repositories/auth_repository.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';

/// Application principale
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: serviceLocator<AuthRepository>(),
          ),
        ),
        // Ajouter d'autres BlocProviders ici
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.router(context);
          
          return MaterialApp.router(
            title: 'GBC CoachIA',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
