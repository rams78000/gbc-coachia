import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // BLoC
  getIt.registerFactory<OnboardingBloc>(() => OnboardingBloc());

  // Repositories

  // Use cases

  // Data sources
}
