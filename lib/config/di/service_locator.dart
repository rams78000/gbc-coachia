import 'package:get_it/get_it.dart';
import 'package:gbc_coachia/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gbc_coachia/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service locator pour l'injection de dépendances
final serviceLocator = GetIt.instance;

/// Initialise les dépendances de l'application
Future<void> initDependencies() async {
  // Services externes
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);

  // Repositories
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sharedPreferences: serviceLocator()),
  );

  // TODO: Ajouter d'autres dépendances au fur et à mesure de l'implémentation
}
