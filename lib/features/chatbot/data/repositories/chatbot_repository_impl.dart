import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../../domain/repositories/chatbot_repository.dart';

/// Implémentation du repository chatbot
class ChatbotRepositoryImpl implements ChatbotRepository {
  /// Clé pour stocker les messages dans SharedPreferences
  static const _messagesKey = 'chatbot_messages';
  
  /// Liste des réponses prédéfinies du chatbot
  final List<String> _predefinedResponses = [
    'Je vous recommande de planifier votre journée le soir précédent pour optimiser votre productivité.',
    'Avez-vous pensé à déléguer certaines tâches administratives pour vous concentrer sur votre cœur de métier ?',
    'Pour améliorer votre trésorerie, envisagez d\'établir un échéancier de facturation plus régulier.',
    'Je vous conseille de consacrer au moins 2 heures par semaine à la prospection de nouveaux clients.',
    'La diversification de vos sources de revenus pourrait renforcer la stabilité financière de votre activité.',
    'Pensez à automatiser vos tâches répétitives pour gagner du temps et réduire les erreurs.',
    'Un bilan trimestriel vous permettrait de mieux ajuster votre stratégie commerciale.',
    'Avez-vous évalué récemment la rentabilité de chacun de vos services ou produits ?',
    'Je vous suggère d\'analyser les performances de votre site web pour optimiser votre présence en ligne.',
    'N\'oubliez pas l\'importance du networking pour développer votre portefeuille de clients.',
  ];

  @override
  Future<String> sendMessage(String message) async {
    // Simuler un délai de réponse
    await Future.delayed(const Duration(seconds: 1));
    
    // Enregistrer le message de l'utilisateur
    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      content: message,
      timestamp: DateTime.now(),
      isUserMessage: true,
    );
    await _saveMessage(userMessage);
    
    // Générer la réponse du chatbot
    final response = _getAIResponse();
    final aiMessage = ChatMessage(
      id: const Uuid().v4(),
      content: response,
      timestamp: DateTime.now(),
      isUserMessage: false,
    );
    await _saveMessage(aiMessage);
    
    return response;
  }

  @override
  Future<List<ChatMessage>> getConversationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getStringList(_messagesKey) ?? [];
    
    return messagesJson
        .map((json) => _chatMessageFromJson(json))
        .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  @override
  Future<void> clearConversationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_messagesKey);
  }

  /// Enregistre un message dans l'historique
  Future<void> _saveMessage(ChatMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getStringList(_messagesKey) ?? [];
    
    messagesJson.add(_chatMessageToJson(message));
    await prefs.setStringList(_messagesKey, messagesJson);
  }

  /// Génère une réponse IA simple
  String _getAIResponse() {
    // Choisir une réponse aléatoire dans la liste des réponses prédéfinies
    final index = DateTime.now().millisecondsSinceEpoch % _predefinedResponses.length;
    return _predefinedResponses[index];
  }

  /// Convertit un ChatMessage en JSON
  String _chatMessageToJson(ChatMessage message) {
    return jsonEncode({
      'id': message.id,
      'content': message.content,
      'timestamp': message.timestamp.toIso8601String(),
      'isUserMessage': message.isUserMessage,
    });
  }

  /// Crée un ChatMessage à partir d'un JSON
  ChatMessage _chatMessageFromJson(String json) {
    final data = jsonDecode(json);
    return ChatMessage(
      id: data['id'],
      content: data['content'],
      timestamp: DateTime.parse(data['timestamp']),
      isUserMessage: data['isUserMessage'],
    );
  }
}
