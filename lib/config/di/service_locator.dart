import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/settings/data/repositories/mock_settings_repository.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> initServiceLocator() async {
  // Services externes
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // Repositories
  getIt.registerLazySingleton<SettingsRepository>(
    () => MockSettingsRepository(getIt<SharedPreferences>()),
  );
  
  // BLoCs seront enregistrés au niveau des écrans pour une gestion de cycle de vie appropriée
}
