/// Interface for the Chatbot Repository
abstract class ChatbotRepository {
  /// Send a message to the chatbot and get a response
  Future<Map<String, dynamic>> sendMessage({
    required String message,
    required String conversationId,
  });
  
  /// Get conversation history
  Future<List<Map<String, dynamic>>> getConversationHistory({
    required String conversationId,
  });
  
  /// Create a new conversation
  Future<String> createConversation({String? title});
  
  /// Get all conversations
  Future<List<Map<String, dynamic>>> getConversations();
  
  /// Delete a conversation
  Future<bool> deleteConversation({required String conversationId});
  
  /// Update conversation title
  Future<bool> updateConversationTitle({
    required String conversationId,
    required String title,
  });
}
