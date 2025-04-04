import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../router/app_router.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Singletons externes
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);

  // Blocs / Cubits
  serviceLocator.registerSingleton<AuthBloc>(
    AuthBloc(preferences: serviceLocator<SharedPreferences>()),
  );

  serviceLocator.registerSingleton<OnboardingBloc>(
    OnboardingBloc(preferences: serviceLocator<SharedPreferences>()),
  );

  // Router
  serviceLocator.registerSingleton<AppRouter>(
    AppRouter(serviceLocator<AuthBloc>()),
  );
}
