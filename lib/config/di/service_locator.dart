import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/chatbot/data/repositories/chatbot_repository_impl.dart';
import '../../features/chatbot/data/sources/local_storage.dart';
import '../../features/chatbot/data/sources/openai_api.dart';
import '../../features/chatbot/domain/repositories/chatbot_repository.dart';
import '../../features/chatbot/presentation/bloc/chatbot_bloc.dart';
import '../router/app_router.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External services
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // Router
  serviceLocator.registerSingleton<AppRouter>(AppRouter());
  
  // HTTP Client
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  
  // Data sources
  serviceLocator.registerLazySingleton<OpenAIApi>(
    () => OpenAIApi(dio: serviceLocator<Dio>()),
  );
  
  serviceLocator.registerLazySingleton<ChatbotLocalStorage>(
    () => ChatbotLocalStorage(preferences: serviceLocator<SharedPreferences>()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<ChatbotRepository>(
    () => ChatbotRepositoryImpl(
      localStorage: serviceLocator<ChatbotLocalStorage>(),
      openAIApi: serviceLocator<OpenAIApi>(),
    ),
  );

  // BLoCs
  serviceLocator.registerFactory<AuthBloc>(
    () => AuthBloc(preferences: serviceLocator<SharedPreferences>()),
  );
  
  serviceLocator.registerFactory<ChatbotBloc>(
    () => ChatbotBloc(repository: serviceLocator<ChatbotRepository>()),
  );
}
