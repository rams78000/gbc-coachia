import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get openAIApiKey {
    // Essayer d'abord de récupérer depuis les variables d'environnement
    final envKey = Platform.environment['OPENAI_API_KEY'];
    if (envKey != null && envKey.isNotEmpty) {
      return envKey;
    }
    
    // Sinon, essayer de récupérer depuis le fichier .env
    final dotEnvKey = dotenv.env['OPENAI_API_KEY'];
    if (dotEnvKey != null && dotEnvKey.isNotEmpty) {
      return dotEnvKey;
    }
    
    throw Exception('OPENAI_API_KEY not found in environment variables or .env file');
  }
  
  static String get openAIBaseUrl {
    return dotenv.env['OPENAI_BASE_URL'] ?? 'https://api.openai.com/v1';
  }
  
  static String get openAIModel {
    return dotenv.env['OPENAI_MODEL'] ?? 'gpt-4o';
  }
}
