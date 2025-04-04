import 'package:get_it/get_it.dart';
import 'package:gbc_coachia/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gbc_coachia/features/auth/domain/repositories/auth_repository.dart';
import 'package:gbc_coachia/features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'package:gbc_coachia/features/finance/data/repositories/mock_finance_repository.dart';
import 'package:gbc_coachia/features/finance/domain/repositories/finance_repository.dart';
import 'package:gbc_coachia/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:gbc_coachia/features/planner/data/repositories/mock_planner_repository.dart';
import 'package:gbc_coachia/features/planner/domain/repositories/planner_repository.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_bloc.dart';

/// Service locator pour l'injection de dépendances
final serviceLocator = GetIt.instance;

/// Initialisation des dépendances de l'application
Future<void> initDependencies() async {
  // Blocs
  serviceLocator.registerFactory(() => ChatbotBloc());
  serviceLocator.registerFactory(() => PlannerBloc(
    repository: serviceLocator(),
  ));
  serviceLocator.registerFactory(() => FinanceBloc(
    repository: serviceLocator(),
  ));
  
  // Repositories
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  serviceLocator.registerLazySingleton<PlannerRepository>(() => MockPlannerRepository());
  serviceLocator.registerLazySingleton<FinanceRepository>(() => MockFinanceRepository());
  
  // Datasources
  
  // Services
  
  // Utilitaires
}
