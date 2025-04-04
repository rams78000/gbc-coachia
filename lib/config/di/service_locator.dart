import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Auth
import 'package:gbc_coachia/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gbc_coachia/features/auth/data/sources/auth_local_source.dart';
import 'package:gbc_coachia/features/auth/domain/repositories/auth_repository.dart';
import 'package:gbc_coachia/features/auth/presentation/bloc/auth_bloc.dart';

// Chatbot
import 'package:gbc_coachia/features/chatbot/data/repositories/chatbot_repository_impl.dart';
import 'package:gbc_coachia/features/chatbot/data/sources/chatbot_remote_source.dart';
import 'package:gbc_coachia/features/chatbot/data/sources/chatbot_local_source.dart';
import 'package:gbc_coachia/features/chatbot/domain/repositories/chatbot_repository.dart';
import 'package:gbc_coachia/features/chatbot/presentation/bloc/chatbot_bloc.dart';

// Finance
import 'package:gbc_coachia/features/finance/data/repositories/transaction_repository_impl.dart';
import 'package:gbc_coachia/features/finance/data/sources/transaction_local_source.dart';
import 'package:gbc_coachia/features/finance/domain/repositories/transaction_repository.dart';
import 'package:gbc_coachia/features/finance/presentation/bloc/finance_bloc.dart';

// Planner
import 'package:gbc_coachia/features/planner/data/repositories/event_repository_impl.dart';
import 'package:gbc_coachia/features/planner/data/sources/event_local_source.dart';
import 'package:gbc_coachia/features/planner/domain/repositories/event_repository.dart';
import 'package:gbc_coachia/features/planner/presentation/bloc/planner_bloc.dart';

// Documents
import 'package:gbc_coachia/features/documents/data/repositories/document_repository_impl.dart';
import 'package:gbc_coachia/features/documents/data/sources/document_local_source.dart';
import 'package:gbc_coachia/features/documents/domain/repositories/document_repository.dart';
import 'package:gbc_coachia/features/documents/presentation/bloc/document_bloc.dart';

// Dashboard
import 'package:gbc_coachia/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:gbc_coachia/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:gbc_coachia/features/dashboard/presentation/bloc/dashboard_bloc.dart';

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
  
  serviceLocator.registerLazySingleton<ChatbotLocalSource>(
    () => ChatbotLocalSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );
  
  serviceLocator.registerLazySingleton<ChatbotRepository>(
    () => ChatbotRepositoryImpl(
      remoteSource: serviceLocator(),
      localSource: serviceLocator(),
      transactionRepository: serviceLocator(),
      eventRepository: serviceLocator(),
      documentRepository: serviceLocator(),
      dashboardRepository: serviceLocator(),
    ),
  );
  
  serviceLocator.registerFactory<ChatbotBloc>(
    () => ChatbotBloc(
      chatbotRepository: serviceLocator(),
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
  
  // Documents
  serviceLocator.registerLazySingleton<DocumentLocalSource>(
    () => DocumentLocalSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );
  
  serviceLocator.registerLazySingleton<DocumentRepository>(
    () => DocumentRepositoryImpl(
      localSource: serviceLocator(),
    ),
  );
  
  serviceLocator.registerFactory<DocumentBloc>(
    () => DocumentBloc(
      repository: serviceLocator(),
    ),
  );
  
  // Dashboard
  serviceLocator.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      transactionRepository: serviceLocator(),
      eventRepository: serviceLocator(),
      documentRepository: serviceLocator(),
    ),
  );
  
  serviceLocator.registerFactory<DashboardBloc>(
    () => DashboardBloc(
      repository: serviceLocator(),
    ),
  );
}
