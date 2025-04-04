import 'package:get_it/get_it.dart';
import 'package:gbc_coachia/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gbc_coachia/config/router/app_router.dart';

/// Instance globale du localisateur de services
final getIt = GetIt.instance;

/// Initialiser le localisateur de services
void setupServiceLocator() {
  // Repositories
  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => const AuthRepositoryImpl(),
  );
  
  // BLoCs
  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepositoryImpl>()),
  );
  
  // Router
  getIt.registerLazySingleton<AppRouter>(
    () => AppRouter(authBloc: getIt<AuthBloc>()),
  );
}
