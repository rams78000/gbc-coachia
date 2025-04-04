import 'package:get_it/get_it.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/chatbot/data/repositories/chatbot_repository_impl.dart';
import '../../features/chatbot/domain/repositories/chatbot_repository.dart';
import '../../features/chatbot/presentation/bloc/chatbot_bloc.dart';
import '../../features/finance/data/repositories/finance_repository_impl.dart';
import '../../features/finance/domain/repositories/finance_repository.dart';
import '../../features/finance/presentation/bloc/finance_bloc.dart';
import '../../features/planner/data/repositories/planner_repository_impl.dart';
import '../../features/planner/domain/repositories/planner_repository.dart';
import '../../features/planner/presentation/bloc/planner_bloc.dart';

/// Instance globale du service locator
final getIt = GetIt.instance;

/// Configure les dépendances de l'application
Future<void> setupServiceLocator() async {
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<ChatbotRepository>(
    () => ChatbotRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<PlannerRepository>(
    () => PlannerRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<FinanceRepository>(
    () => FinanceRepositoryImpl(),
  );
  
  // Blocs
  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );
  
  getIt.registerLazySingleton<ChatbotBloc>(
    () => ChatbotBloc(chatbotRepository: getIt<ChatbotRepository>()),
  );
  
  getIt.registerLazySingleton<PlannerBloc>(
    () => PlannerBloc(plannerRepository: getIt<PlannerRepository>()),
  );
  
  getIt.registerLazySingleton<FinanceBloc>(
    () => FinanceBloc(financeRepository: getIt<FinanceRepository>()),
  );
}
