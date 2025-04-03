import 'package:uuid/uuid.dart';

import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chatbot_repository.dart';

/// Implementation of ChatbotRepository
class ChatbotRepositoryImpl implements ChatbotRepository {
  /// In-memory conversations for testing, will be replaced with API or local storage
  final List<Conversation> _conversations = [];
  
  /// Uuid generator
  final Uuid _uuid = const Uuid();

  @override
  Future<List<Conversation>> getConversations() async {
    // TODO: Implement with API or local storage
    return _conversations;
  }

  @override
  Future<Conversation?> getConversationById(String id) async {
    // TODO: Implement with API or local storage
    return _conversations.firstWhere(
      (conversation) => conversation.id == id,
      orElse: () => throw Exception('Conversation not found'),
    );
  }

  @override
  Future<Conversation> createConversation(String title) async {
    // TODO: Implement with API or local storage
    final newConversation = Conversation(
      id: _uuid.v4(),
      title: title,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _conversations.add(newConversation);
    return newConversation;
  }

  @override
  Future<Conversation> updateConversation(Conversation conversation) async {
    // TODO: Implement with API or local storage
    final index = _conversations.indexWhere(
      (c) => c.id == conversation.id,
    );
    
    if (index != -1) {
      _conversations[index] = conversation;
      return conversation;
    } else {
      throw Exception('Conversation not found');
    }
  }

  @override
  Future<bool> deleteConversation(String id) async {
    // TODO: Implement with API or local storage
    final index = _conversations.indexWhere(
      (conversation) => conversation.id == id,
    );
    
    if (index != -1) {
      _conversations.removeAt(index);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<Message>> getMessages(String conversationId) async {
    // TODO: Implement with API or local storage
    final conversation = await getConversationById(conversationId);
    return conversation?.messages ?? [];
  }

  @override
  Future<Message> sendMessage(String conversationId, String content, List<String> attachments) async {
    // Create user message
    final userMessage = Message(
      id: _uuid.v4(),
      content: content,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      attachments: attachments,
      createdAt: DateTime.now(),
    );
    
    // Save user message
    await saveMessage(conversationId, userMessage);
    
    // Generate AI response
    return generateResponse(conversationId, userMessage);
  }

  @override
  Future<Message> generateResponse(String conversationId, Message userMessage) async {
    // TODO: Implement with API call to AI service
    // This is a mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    final response = Message(
      id: _uuid.v4(),
      content: "This is a placeholder AI response",
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      createdAt: DateTime.now(),
    );
    
    // Save AI response
    await saveMessage(conversationId, response);
    
    return response;
  }

  @override
  Future<List<String>> getSuggestedPrompts(String conversationId) async {
    // TODO: Implement with API or local storage
    return [
      "Tell me more about managing my time better",
      "How can I improve my business strategy?",
      "What are some marketing tips for my freelance work?",
    ];
  }

  @override
  Future<Message> saveMessage(String conversationId, Message message) async {
    // TODO: Implement with API or local storage
    final conversationIndex = _conversations.indexWhere(
      (conversation) => conversation.id == conversationId,
    );
    
    if (conversationIndex != -1) {
      final conversation = _conversations[conversationIndex];
      final updatedMessages = List.of(conversation.messages)..add(message);
      
      final updatedConversation = conversation.copyWith(
        messages: updatedMessages,
        lastMessageTimestamp: message.timestamp,
        updatedAt: DateTime.now(),
      );
      
      _conversations[conversationIndex] = updatedConversation;
      return message;
    } else {
      throw Exception('Conversation not found');
    }
  }

  @override
  Future<bool> markMessagesAsRead(String conversationId) async {
    // TODO: Implement with API or local storage
    final conversationIndex = _conversations.indexWhere(
      (conversation) => conversation.id == conversationId,
    );
    
    if (conversationIndex != -1) {
      final conversation = _conversations[conversationIndex];
      final updatedMessages = conversation.messages
          .map((message) => message.copyWith(isRead: true))
          .toList();
      
      _conversations[conversationIndex] = conversation.copyWith(
        messages: updatedMessages,
      );
      
      return true;
    } else {
      return false;
    }
  }
}