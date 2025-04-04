import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/di/service_locator.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider<OnboardingBloc>(
          create: (context) => serviceLocator<OnboardingBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'GBC CoachIA',
        theme: ThemeData(
          primaryColor: const Color(0xFFB87333), // Couleur cuivre/bronze
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFB87333),
            secondary: const Color(0xFFFFD700), // Couleur or
          ),
          fontFamily: 'Inter',
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFFB87333), // Couleur cuivre/bronze
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFB87333),
            secondary: const Color(0xFFFFD700), // Couleur or
            brightness: Brightness.dark,
          ),
          fontFamily: 'Inter',
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routerConfig: serviceLocator<AppRouter>().router,
      ),
    );
  }
}
