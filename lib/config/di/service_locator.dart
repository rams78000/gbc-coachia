import 'package:get_it/get_it.dart';

import '../../features/onboarding/data/repositories/mock_onboarding_repository.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    // Repositories
    getIt.registerLazySingleton<OnboardingRepository>(
      () => MockOnboardingRepository(),
    );
    
    // BLoCs
    getIt.registerFactory<OnboardingBloc>(
      () => OnboardingBloc(repository: getIt<OnboardingRepository>()),
    );
  }
}
