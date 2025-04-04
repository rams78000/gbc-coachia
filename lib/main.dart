import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'config/di/service_locator.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';

void main() async {
  // Initialiser Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Charger les variables d'environnement
  await dotenv.load(fileName: '.env');
  
  // Configurer les services
  await setupServiceLocator();
  
  // Lancer l'application
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => serviceLocator<AuthBloc>()
            ..add(const AuthCheckRequested()),
        ),
        BlocProvider<OnboardingBloc>(
          create: (context) => OnboardingBloc()
            ..add(const OnboardingStatusRequested()),
        ),
      ],
      child: const App(),
    ),
  );
}
