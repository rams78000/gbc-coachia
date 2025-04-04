import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gbc_coachia/features/chatbot/domain/entities/ai_module_feature.dart';
import 'package:gbc_coachia/features/chatbot/domain/entities/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Source de données pour interagir avec les API d'IA
abstract class ChatbotRemoteSource {
  /// Envoie un message à l'API OpenAI et retourne la réponse
  Future<Message> sendMessage(List<Message> messages, {List<AIModuleFeature>? features});
  
  /// Vérifie si la clé API est valide
  Future<bool> isApiKeyValid();
  
  /// Configure la clé API
  Future<void> setApiKey(String apiKey);
}

class ChatbotRemoteSourceImpl implements ChatbotRemoteSource {
  final FlutterSecureStorage _secureStorage;
  final Dio _dio;

  // URL de base pour l'API OpenAI
  static const String _openAiBaseUrl = 'https://api.openai.com/v1';
  
  // Modèle à utiliser pour le chat
  static const String _defaultModel = 'gpt-4o';
  
  // Clé pour stocker la clé API dans le stockage sécurisé
  static const String _apiKeyStorageKey = 'openai_api_key';
  
  // Instructions par défaut pour l'assistant
  static const String _systemPrompt = '''
Tu es un assistant virtuel spécialisé pour les entrepreneurs et freelances, nommé "GBC CoachIA". 
Ton rôle est d'aider avec la gestion d'entreprise, les finances, la planification et l'organisation.
Sois précis, concis et professionnel tout en restant accessible et chaleureux. 
Donne des conseils pratiques et adaptés aux entrepreneurs.
Propose des actions concrètes quand c'est pertinent.

Quand tu suggères des actions qui peuvent être effectuées dans l'application (comme créer un événement,
ajouter une transaction, etc.), utilise les fonctions disponibles plutôt que de simplement décrire comment le faire.
''';

  ChatbotRemoteSourceImpl({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage,
       _dio = Dio(BaseOptions(
         baseUrl: _openAiBaseUrl,
         connectTimeout: const Duration(seconds: 30),
         receiveTimeout: const Duration(seconds: 30),
       ));

  @override
  Future<Message> sendMessage(List<Message> messages, {List<AIModuleFeature>? features}) async {
    try {
      // Récupérer la clé API
      final apiKey = await _secureStorage.read(key: _apiKeyStorageKey);
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('Clé API OpenAI non configurée. Veuillez ajouter votre clé API dans les paramètres.');
      }
      
      // Convertir les messages au format OpenAI
      final openAiMessages = messages.map((m) => m.toOpenAIMessage()).toList();
      
      // Ajouter le message système au début s'il n'existe pas déjà
      if (!messages.any((m) => m.role == MessageRole.system)) {
        openAiMessages.insert(0, {
          'role': 'system',
          'content': _systemPrompt,
        });
      }

      // Préparer les données pour la requête
      final Map<String, dynamic> requestData = {
        'model': _defaultModel,
        'messages': openAiMessages,
        'temperature': 0.7,
      };
      
      // Ajouter les fonctions si elles sont fournies
      if (features != null && features.isNotEmpty) {
        requestData['tools'] = features.map((feature) {
          return {
            'type': 'function',
            'function': feature.toFunctionDefinition(),
          };
        }).toList();
        
        requestData['tool_choice'] = 'auto';
      }
      
      // Configurer les en-têtes
      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };
      
      // Envoyer la requête
      final response = await _dio.post(
        '/chat/completions',
        data: requestData,
        options: Options(headers: headers),
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        final choice = responseData['choices'][0];
        final responseMessage = choice['message'];
        
        // Créer un ID unique pour le message
        final messageId = const Uuid().v4();
        
        // Vérifier si une fonction a été appelée
        if (responseMessage.containsKey('tool_calls') && 
            responseMessage['tool_calls'] != null &&
            responseMessage['tool_calls'].isNotEmpty) {
          
          final toolCall = responseMessage['tool_calls'][0];
          final functionCall = toolCall['function'];
          
          return Message(
            id: messageId,
            content: jsonEncode({
              'function_name': functionCall['name'],
              'arguments': functionCall['arguments'],
              'explanation': responseMessage['content'] ?? 'Action à effectuer',
            }),
            role: MessageRole.assistant,
            timestamp: DateTime.now(),
          );
        } else {
          // Message texte standard
          return Message(
            id: messageId,
            content: responseMessage['content'],
            role: MessageRole.assistant,
            timestamp: DateTime.now(),
          );
        }
      } else {
        throw Exception('Erreur lors de la communication avec l\'API: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          throw Exception('Clé API invalide. Veuillez vérifier votre clé API dans les paramètres.');
        } else {
          throw Exception('Erreur API: ${e.response!.statusCode} - ${e.response!.data['error']['message'] ?? e.message}');
        }
      } else {
        throw Exception('Erreur de connexion: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi du message: $e');
    }
  }

  @override
  Future<bool> isApiKeyValid() async {
    try {
      final apiKey = await _secureStorage.read(key: _apiKeyStorageKey);
      
      if (apiKey == null || apiKey.isEmpty) {
        return false;
      }
      
      // Effectuer une requête simple pour vérifier la validité de la clé
      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };
      
      final response = await _dio.get(
        '/models',
        options: Options(headers: headers),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> setApiKey(String apiKey) async {
    await _secureStorage.write(key: _apiKeyStorageKey, value: apiKey);
  }
}
