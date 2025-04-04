import '../entities/conversation.dart';
import '../entities/message.dart';

/// Interface pour le repository Chatbot
abstract class ChatbotRepository {
  /// Récupère toutes les conversations
  Future<List<Conversation>> getConversations();
  
  /// Récupère une conversation par son ID
  Future<Conversation?> getConversationById(String id);
  
  /// Crée une nouvelle conversation
  Future<Conversation> createConversation(String title);
  
  /// Supprime une conversation
  Future<void> deleteConversation(String id);
  
  /// Envoie un message dans une conversation et obtient la réponse de l'IA
  Future<Message> sendMessage(
    String conversationId,
    String content, {
    bool useFeatures = true,
  });
  
  /// Vérifie si la clé API est valide
  Future<bool> isApiKeyValid();
  
  /// Configure la clé API
  Future<void> setApiKey(String apiKey);
}
