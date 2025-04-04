import '../entities/conversation.dart';
import '../entities/message.dart';

abstract class ChatbotRepository {
  // Récupérer toutes les conversations
  Future<List<Conversation>> getConversations();
  
  // Récupérer une conversation par son ID
  Future<Conversation?> getConversationById(String id);
  
  // Créer une nouvelle conversation
  Future<Conversation> createConversation(String title);
  
  // Mettre à jour une conversation
  Future<void> updateConversation(Conversation conversation);
  
  // Supprimer une conversation
  Future<void> deleteConversation(String id);
  
  // Envoyer un message à l'IA et obtenir une réponse
  Future<Message> sendMessageToAI(Conversation conversation, String content);
}
