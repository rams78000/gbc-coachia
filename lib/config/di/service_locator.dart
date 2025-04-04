import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Auth
import 'package:gbc_coachai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gbc_coachai/features/auth/data/sources/auth_local_source.dart';
import 'package:gbc_coachai/features/auth/domain/repositories/auth_repository.dart';
import 'package:gbc_coachai/features/auth/presentation/bloc/auth_bloc.dart';

// Chatbot
import 'package:gbc_coachai/features/chatbot/data/repositories/chatbot_repository_impl.dart';
import 'package:gbc_coachai/features/chatbot/data/sources/chatbot_remote_source.dart';
import 'package:gbc_coachai/features/chatbot/domain/repositories/chatbot_repository.dart';
import 'package:gbc_coachai/features/chatbot/presentation/bloc/chatbot_bloc.dart';

// Finance
import 'package:gbc_coachai/features/finance/data/repositories/transaction_repository_impl.dart';
import 'package:gbc_coachai/features/finance/data/sources/transaction_local_source.dart';
import 'package:gbc_coachai/features/finance/domain/repositories/transaction_repository.dart';
import 'package:gbc_coachai/features/finance/presentation/bloc/finance_bloc.dart';

// Planner
import 'package:gbc_coachai/features/planner/data/repositories/event_repository_impl.dart';
import 'package:gbc_coachai/features/planner/data/sources/event_local_source.dart';
import 'package:gbc_coachai/features/planner/domain/repositories/event_repository.dart';
import 'package:gbc_coachai/features/planner/presentation/bloc/planner_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initServiceLocator() async {
  // External services
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);
  
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage()
  );

  // Auth
  serviceLocator.registerLazySingleton<AuthLocalSource>(
    () => AuthLocalSourceImpl(
      sharedPreferences: serviceLocator(),
      secureStorage: serviceLocator(),
    ),
  );
  
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localSource: serviceLocator(),
    ),
  );
  
  serviceLocator.registerFactory<AuthBloc>(
    () => AuthBloc(
      repository: serviceLocator(),
    ),
  );

  // Chatbot
  serviceLocator.registerLazySingleton<ChatbotRemoteSource>(
    () => ChatbotRemoteSourceImpl(
      secureStorage: serviceLocator(),
    ),
  );
  
  serviceLocator.registerLazySingleton<ChatbotRepository>(
    () => ChatbotRepositoryImpl(
      remoteSource: serviceLocator(),
    ),
  );
  
  serviceLocator.registerFactory<ChatbotBloc>(
    () => ChatbotBloc(
      repository: serviceLocator(),
    ),
  );

  // Finance
  serviceLocator.registerLazySingleton<TransactionLocalSource>(
    () => TransactionLocalSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );
  
  serviceLocator.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      localSource: serviceLocator(),
    ),
  );
  
  serviceLocator.registerFactory<FinanceBloc>(
    () => FinanceBloc(
      repository: serviceLocator(),
    ),
  );

  // Planner
  serviceLocator.registerLazySingleton<EventLocalSource>(
    () => EventLocalSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );
  
  serviceLocator.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(
      localSource: serviceLocator(),
    ),
  );
  
  serviceLocator.registerFactory<PlannerBloc>(
    () => PlannerBloc(
      repository: serviceLocator(),
    ),
  );
}
