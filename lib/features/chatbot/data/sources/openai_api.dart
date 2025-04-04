import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/env_config.dart';
import '../../domain/entities/ai_module_feature.dart';
import '../../domain/entities/message.dart';

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
  Future<Message> sendMessage(List<Message> messages, {List<AIModuleFeature>? features}) async {
    try {
      // Configuration du système avancée pour le coach d'entreprise
      final systemPrompt = _buildSystemPrompt(features);
      final systemMessage = Message(
        id: _uuid.v4(),
        content: systemPrompt,
        role: MessageRole.system,
        timestamp: DateTime.now(),
      );
      
      // Préparer les messages pour l'API en incluant le message système
      final List<Map<String, dynamic>> apiMessages = [
        systemMessage.toOpenAIMessage(),
        ...messages.map((m) => m.toOpenAIMessage()),
      ];
      
      // Préparer les fonctions si disponibles
      final requestData = {
        'model': EnvConfig.openAIModel,
        'messages': apiMessages,
        'max_tokens': 1500,
        'temperature': 0.7,
      };
      
      // Ajouter les fonctions et forcer leur utilisation si nécessaire
      if (features != null && features.isNotEmpty) {
        requestData['functions'] = features.map((f) => f.toFunctionDefinition()).toList();
        requestData['function_call'] = 'auto';
      }
      
      // Requête à l'API OpenAI
      final response = await _dio.post(
        '/chat/completions',
        data: requestData,
      );
      
      // Vérifier si la réponse est valide
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final choices = data['choices'] as List;
        
        if (choices.isNotEmpty) {
          final choice = choices.first;
          final messageData = choice['message'];
          
          // Vérifier si l'IA a appelé une fonction
          if (messageData.containsKey('function_call')) {
            final functionCall = messageData['function_call'];
            final functionName = functionCall['name'];
            final functionArgs = functionCall['arguments'];
            
            // Créer un message formaté pour l'appel de fonction
            final functionCallObject = {
              'function_name': functionName,
              'arguments': functionArgs,
              'explanation': 'Je vais exécuter cette action pour vous. Un instant...',
            };
            
            return Message(
              id: _uuid.v4(),
              content: jsonEncode(functionCallObject),
              role: MessageRole.assistant,
              timestamp: DateTime.now(),
              type: _getFunctionMessageType(functionName),
            );
          } else {
            // Réponse textuelle normale
            final content = messageData['content'] as String;
            
            // Déterminer le type de message basé sur le contenu
            final messageType = _detectMessageType(content);
            
            // Créer un nouveau message avec la réponse de l'IA
            return Message(
              id: _uuid.v4(),
              content: content,
              role: MessageRole.assistant,
              timestamp: DateTime.now(),
              type: messageType,
            );
          }
        }
      }
      
      throw Exception('Réponse API invalide: ${response.statusCode}');
    } on DioException catch (e) {
      return Message(
        id: _uuid.v4(),
        content: 'Erreur de communication avec l\'assistant IA: ${e.message}.\n\nVeuillez vérifier votre connexion et réessayer.',
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
        type: MessageType.error,
      );
    } catch (e) {
      return Message(
        id: _uuid.v4(),
        content: 'Une erreur inattendue s\'est produite: $e',
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
        type: MessageType.error,
      );
    }
  }
  
  /// Construit un prompt système avancé adapté aux besoins actuels
  String _buildSystemPrompt(List<AIModuleFeature>? features) {
    String basePrompt = """
Tu es GBC CoachIA, un assistant professionnel spécialisé pour les entrepreneurs et freelances francophones.

PRINCIPES FONDAMENTAUX:
- Tes réponses sont toujours en français
- Ton ton est professionnel, encourageant et bienveillant
- Tu offres des conseils concrets et actionnables
- Tu es précis et structuré dans tes réponses
- Tu prends en compte le contexte de l'entrepreneur/freelance

DOMAINES D'EXPERTISE:
- Gestion financière: comptabilité, facturation, prévisions, optimisation fiscale
- Productivité: gestion du temps, organisation, automatisation de tâches
- Planification: calendrier, rendez-vous, échéances, projets
- Marketing: stratégies, acquisition clients, fidélisation, présence en ligne
- Développement commercial: prospection, négociation, partenariats
- Administration: formalités, réglementations, obligations légales
- Gestion documentaire: contrats, devis, factures, rapports

FORMAT DE RÉPONSE:
- Structure tes réponses avec des titres, sous-titres et listes quand c'est pertinent
- Utilise des exemples concrets adaptés à la situation de l'utilisateur
- Présente les informations financières sous forme de tableaux quand possible
- Pour les réponses longues, inclus un résumé au début
""";

    // Ajouter des consignes concernant les fonctions disponibles
    if (features != null && features.isNotEmpty) {
      basePrompt += "\n\nFONCTIONS DISPONIBLES:\n";
      basePrompt += "Tu as accès aux fonctions suivantes pour aider l'utilisateur. Utilise-les quand c'est pertinent:\n";
      
      for (final feature in features) {
        basePrompt += "- ${feature.name}: ${feature.description}\n";
      }
      
      basePrompt += "\nUtilise ces fonctions de manière proactive lorsqu'elles permettent de mieux répondre aux besoins de l'utilisateur.";
    }
    
    return basePrompt;
  }
  
  /// Detecte le type de message basé sur son contenu
  MessageType _detectMessageType(String content) {
    final contentLower = content.toLowerCase();
    
    if (contentLower.contains('erreur') || 
        contentLower.contains('désolé') && contentLower.contains('ne peut pas')) {
      return MessageType.error;
    } else if ((contentLower.contains('voici') || contentLower.contains('voilà')) && 
              (contentLower.contains('suggère') || contentLower.contains('suggestion') || 
               contentLower.contains('recommand') || contentLower.contains('conseil'))) {
      return MessageType.suggestion;
    } else if ((contentLower.contains('analysé') || contentLower.contains('analyse') || 
                contentLower.contains('évalué') || contentLower.contains('examiné')) &&
              !(contentLower.contains('finance') || contentLower.contains('€') || 
                contentLower.contains('euro'))) {
      return MessageType.analysis;
    } else if (contentLower.contains('tâche') || contentLower.contains('todo') || 
              contentLower.contains('action') || contentLower.contains('objectif') ||
              contentLower.contains('étape')) {
      return MessageType.taskCreation;
    } else if ((contentLower.contains('document') || contentLower.contains('contrat') || 
               contentLower.contains('modèle') || contentLower.contains('template')) &&
               (contentLower.contains('généré') || contentLower.contains('créé'))) {
      return MessageType.documentGeneration;
    } else if (contentLower.contains('finance') || contentLower.contains('budget') || 
             contentLower.contains('revenu') || contentLower.contains('dépense') ||
             contentLower.contains('€') || contentLower.contains('euro')) {
      return MessageType.financialAnalysis;
    } else {
      return MessageType.text;
    }
  }
  
  /// Détermine le type de message basé sur le nom de la fonction appelée
  MessageType _getFunctionMessageType(String functionName) {
    switch (functionName) {
      case 'getFinancialSummary':
      case 'createTransaction':
        return MessageType.financialAnalysis;
      case 'getUpcomingEvents':
      case 'createEvent':
        return MessageType.taskCreation;
      case 'searchDocuments':
        return MessageType.documentGeneration;
      case 'getBusinessInsights':
        return MessageType.analysis;
      default:
        return MessageType.text;
    }
  }
  
  /// Vérifie si la clé API OpenAI est valide
  Future<bool> isApiKeyValid() async {
    try {
      final response = await _dio.get('/models');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
}
