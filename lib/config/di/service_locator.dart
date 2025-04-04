import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/chatbot/presentation/bloc/chatbot_bloc.dart';
import '../../features/finance/presentation/bloc/finance_bloc.dart';
import '../../features/planner/presentation/bloc/planner_bloc.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // BLoCs
  getIt.registerFactory<OnboardingBloc>(() => OnboardingBloc());
  
  getIt.registerFactory<ChatbotBloc>(
    () => ChatbotBloc(preferences: getIt<SharedPreferences>())
  );
  
  getIt.registerFactory<FinanceBloc>(
    () => FinanceBloc(preferences: getIt<SharedPreferences>())
  );
  
  getIt.registerFactory<PlannerBloc>(
    () => PlannerBloc(preferences: getIt<SharedPreferences>())
  );
  
  getIt.registerFactory<SettingsBloc>(
    () => SettingsBloc(preferences: getIt<SharedPreferences>())
  );

  // Repositories

  // Use cases

  // Data sources
}
