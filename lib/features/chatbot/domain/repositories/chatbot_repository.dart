import '../entities/conversation.dart';
import '../entities/message.dart';

/// Chatbot repository interface
abstract class ChatbotRepository {
  /// Get all conversations
  Future<List<Conversation>> getConversations();
  
  /// Get conversation by ID
  Future<Conversation?> getConversationById(String id);
  
  /// Create a new conversation
  Future<Conversation> createConversation(String title);
  
  /// Update conversation
  Future<Conversation> updateConversation(Conversation conversation);
  
  /// Delete conversation
  Future<bool> deleteConversation(String id);
  
  /// Get messages for a conversation
  Future<List<Message>> getMessages(String conversationId);
  
  /// Send a message to the chatbot
  Future<Message> sendMessage(String conversationId, String content, List<String> attachments);
  
  /// Generate response from AI
  Future<Message> generateResponse(String conversationId, Message userMessage);
  
  /// Get suggested prompts for a conversation
  Future<List<String>> getSuggestedPrompts(String conversationId);
  
  /// Save message
  Future<Message> saveMessage(String conversationId, Message message);
  
  /// Mark messages as read
  Future<bool> markMessagesAsRead(String conversationId);
}