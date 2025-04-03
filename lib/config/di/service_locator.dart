import 'package:get_it/get_it.dart';
import 'package:gbc_coachia/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gbc_coachia/features/auth/domain/repositories/auth_repository.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gbc_coachia/features/chatbot/data/repositories/chatbot_repository_impl.dart';
import 'package:gbc_coachia/features/chatbot/domain/repositories/chatbot_repository.dart';
import 'package:gbc_coachia/features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'package:gbc_coachia/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:gbc_coachia/features/finance/domain/repositories/finance_repository.dart';
import 'package:gbc_coachia/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:gbc_coachia/features/planner/data/repositories/planner_repository_impl.dart';
import 'package:gbc_coachia/features/planner/domain/repositories/planner_repository.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_bloc.dart';
import 'package:gbc_coachia/features/theme/presentation/bloc/theme_bloc.dart';

/// Initialize service locator
Future<void> initServiceLocator() async {
  final getIt = GetIt.instance;
  
  // Register repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<ChatbotRepository>(() => ChatbotRepositoryImpl());
  getIt.registerLazySingleton<PlannerRepository>(() => PlannerRepositoryImpl());
  getIt.registerLazySingleton<FinanceRepository>(() => FinanceRepositoryImpl());
  
  // Register BLoCs
  getIt.registerFactory(() => AuthBloc(getIt<AuthRepository>()));
  getIt.registerFactory(() => ChatbotBloc(getIt<ChatbotRepository>()));
  getIt.registerFactory(() => PlannerBloc(getIt<PlannerRepository>()));
  getIt.registerFactory(() => FinanceBloc(getIt<FinanceRepository>()));
  getIt.registerFactory(() => ThemeBloc());
}