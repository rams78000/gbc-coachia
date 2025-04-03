import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../router/app_router.dart';

/// Initialisation du service locator (singleton)
Future<void> initServiceLocator() async {
  final getIt = GetIt.instance;
  
  // Services externes
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // Router
  getIt.registerSingleton<AppRouter>(AppRouter());
  
  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(sharedPreferences: sharedPreferences),
  );
  
  // BLoCs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );
}
