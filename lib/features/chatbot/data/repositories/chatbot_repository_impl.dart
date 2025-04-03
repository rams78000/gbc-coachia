import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repositories/chatbot_repository.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final Dio dio;
  final _uuid = const Uuid();
  
  ChatbotRepositoryImpl({required this.dio});
  
  @override
  Future<Map<String, dynamic>> sendMessage({
    required String message,
    required String conversationId,
  }) async {
    try {
      // In a real app, this would be an API call to OpenAI or another AI service
      final response = await dio.post(
        'chat/completions',
        data: {
          'model': 'gpt-4',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant for entrepreneurs and freelancers.'},
            {'role': 'user', 'content': message}
          ],
          'temperature': 0.7,
        },
      );
      
      if (response.statusCode == 200) {
        final aiMessage = response.data['choices'][0]['message']['content'];
        
        // Store message in conversation history
        await _saveMessageToHistory(
          conversationId: conversationId,
          message: message,
          response: aiMessage,
        );
        
        return {
          'id': _uuid.v4(),
          'content': aiMessage,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'role': 'assistant',
        };
      } else {
        // Fallback for demo purposes
        return _getFallbackResponse(message);
      }
    } catch (e) {
      print('Error sending message: $e');
      // Fallback for demo purposes
      return _getFallbackResponse(message);
    }
  }
  
  Map<String, dynamic> _getFallbackResponse(String message) {
    String response;
    
    // Simple demo fallback
    if (message.toLowerCase().contains('hello') || 
        message.toLowerCase().contains('hi')) {
      response = 'Hello! How can I assist you with your business today?';
    } else if (message.toLowerCase().contains('business plan')) {
      response = 'Creating a business plan is crucial. Start by defining your objectives, target market, unique value proposition, marketing strategy, and financial projections.';
    } else if (message.toLowerCase().contains('marketing')) {
      response = 'Effective marketing strategies for small businesses include: content marketing, social media engagement, email campaigns, SEO, and networking events.';
    } else {
      response = 'I\'d love to help with that. Could you provide more details so I can give you the most relevant advice?';
    }
    
    return {
      'id': _uuid.v4(),
      'content': response,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'role': 'assistant',
    };
  }
  
  Future<void> _saveMessageToHistory({
    required String conversationId,
    required String message,
    required String response,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing conversation history
      final history = await getConversationHistory(conversationId: conversationId);
      
      // Add new messages
      history.add({
        'id': _uuid.v4(),
        'content': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'role': 'user',
      });
      
      history.add({
        'id': _uuid.v4(),
        'content': response,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'role': 'assistant',
      });
      
      // Save updated history
      await prefs.setString('conversation_$conversationId', jsonEncode(history));
      
      // Update conversation metadata
      await _updateConversationMetadata(conversationId, message);
    } catch (e) {
      print('Error saving message history: $e');
    }
  }
  
  Future<void> _updateConversationMetadata(String conversationId, String lastMessage) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing conversations
      final List<Map<String, dynamic>> conversations = await getConversations();
      
      // Find and update the relevant conversation
      for (int i = 0; i < conversations.length; i++) {
        if (conversations[i]['id'] == conversationId) {
          conversations[i]['lastMessage'] = lastMessage;
          conversations[i]['updatedAt'] = DateTime.now().millisecondsSinceEpoch;
          break;
        }
      }
      
      // Save updated conversations list
      await prefs.setString('conversations', jsonEncode(conversations));
    } catch (e) {
      print('Error updating conversation metadata: $e');
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getConversationHistory({
    required String conversationId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? historyJson = prefs.getString('conversation_$conversationId');
      
      if (historyJson != null) {
        final List<dynamic> parsed = jsonDecode(historyJson);
        return parsed.map((item) => Map<String, dynamic>.from(item)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error getting conversation history: $e');
      return [];
    }
  }
  
  @override
  Future<String> createConversation({String? title}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Generate new conversation ID
      final String id = _uuid.v4();
      
      // Get existing conversations
      final List<Map<String, dynamic>> conversations = await getConversations();
      
      // Add new conversation
      conversations.add({
        'id': id,
        'title': title ?? 'New Conversation',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
        'lastMessage': '',
      });
      
      // Save updated conversations list
      await prefs.setString('conversations', jsonEncode(conversations));
      
      return id;
    } catch (e) {
      print('Error creating conversation: $e');
      return _uuid.v4(); // Fallback to return a valid ID
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? conversationsJson = prefs.getString('conversations');
      
      if (conversationsJson != null) {
        final List<dynamic> parsed = jsonDecode(conversationsJson);
        return parsed.map((item) => Map<String, dynamic>.from(item)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error getting conversations: $e');
      return [];
    }
  }
  
  @override
  Future<bool> deleteConversation({required String conversationId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing conversations
      final List<Map<String, dynamic>> conversations = await getConversations();
      
      // Remove the conversation
      conversations.removeWhere((conv) => conv['id'] == conversationId);
      
      // Save updated conversations list
      await prefs.setString('conversations', jsonEncode(conversations));
      
      // Remove conversation history
      await prefs.remove('conversation_$conversationId');
      
      return true;
    } catch (e) {
      print('Error deleting conversation: $e');
      return false;
    }
  }
  
  @override
  Future<bool> updateConversationTitle({
    required String conversationId,
    required String title,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing conversations
      final List<Map<String, dynamic>> conversations = await getConversations();
      
      // Find and update the relevant conversation
      for (int i = 0; i < conversations.length; i++) {
        if (conversations[i]['id'] == conversationId) {
          conversations[i]['title'] = title;
          break;
        }
      }
      
      // Save updated conversations list
      await prefs.setString('conversations', jsonEncode(conversations));
      
      return true;
    } catch (e) {
      print('Error updating conversation title: $e');
      return false;
    }
  }
}
