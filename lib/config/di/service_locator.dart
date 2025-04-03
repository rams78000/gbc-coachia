import 'package:get_it/get_it.dart';
import 'package:gbc_coachia/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gbc_coachia/features/auth/domain/repositories/auth_repository.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gbc_coachia/features/theme/presentation/bloc/theme_bloc.dart';

/// Initialize service locator
Future<void> initServiceLocator() async {
  final getIt = GetIt.instance;
  
  // Register repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  
  // Register BLoCs
  getIt.registerFactory(() => AuthBloc(getIt<AuthRepository>()));
  getIt.registerFactory(() => ThemeBloc());
}
