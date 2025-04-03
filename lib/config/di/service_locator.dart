import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/chatbot/data/repositories/chatbot_repository_impl.dart';
import '../../features/chatbot/domain/repositories/chatbot_repository.dart';
import '../../features/chatbot/presentation/bloc/chatbot_bloc.dart';

/// GetIt instance for dependency injection
final serviceLocator = GetIt.instance;

/// Initialize all dependencies
Future<void> initDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);
  
  final dio = Dio();
  serviceLocator.registerSingleton<Dio>(dio);
  
  // Repositories
  serviceLocator.registerLazySingleton<ChatbotRepository>(
    () => ChatbotRepositoryImpl(dio: serviceLocator<Dio>()),
  );
  
  // BLoCs
  serviceLocator.registerFactory<ChatbotBloc>(
    () => ChatbotBloc(chatbotRepository: serviceLocator<ChatbotRepository>()),
  );
  
  // TODO: Add more dependencies for other features
}
