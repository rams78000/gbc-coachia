import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/env_config.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/conversation.dart';

class OpenAIApi {
  final Dio _dio;
  final Uuid _uuid = const Uuid();
  
  OpenAIApi({Dio? dio}) 
      : _dio = dio ?? Dio() {
    _dio.options.baseUrl = EnvConfig.openAIBaseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${EnvConfig.openAIApiKey}',
    };
  }
  
  /// Envoie un message à l'API OpenAI et retourne la réponse
  Future<Message> sendMessage(Conversation conversation) async {
    try {
      // Configuration du système pour le coach d'entreprise
      final systemMessage = Message(
        id: _uuid.v4(),
        content: "Tu es CoachIA, un assistant de gestion d'entreprise intelligent pour les entrepreneurs et freelances. "
            "Tu aides avec la gestion financière, la productivité, la planification et les conseils stratégiques. "
            "Tu es un partenaire de confiance qui simplifie la gestion d'entreprise et favorise la croissance.",
        role: MessageRole.system,
        timestamp: DateTime.now(),
      );
      
      // Préparer les messages pour l'API en incluant le message système
      final List<Map<String, dynamic>> messages = [
        systemMessage.toOpenAIMessage(),
        ...conversation.messages.map((m) => m.toOpenAIMessage()),
      ];
      
      // Requête à l'API OpenAI
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': EnvConfig.openAIModel,
          'messages': messages,
          'max_tokens': 1000,
          'temperature': 0.7,
        },
      );
      
      // Vérifier si la réponse est valide
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final choices = data['choices'] as List;
        
        if (choices.isNotEmpty) {
          final choice = choices.first;
          final content = choice['message']['content'] as String;
          
          // Créer un nouveau message avec la réponse de l'IA
          return Message(
            id: _uuid.v4(),
            content: content,
            role: MessageRole.assistant,
            timestamp: DateTime.now(),
          );
        }
      }
      
      throw Exception('Réponse API invalide: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Erreur API OpenAI: ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }
}
