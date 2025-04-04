import 'dart:convert';

import 'package:gbc_coachia/features/chatbot/domain/entities/conversation.dart';
import 'package:gbc_coachia/features/chatbot/domain/entities/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Source de données locale pour gérer les conversations et messages
abstract class ChatbotLocalSource {
  /// Sauvegarde une conversation
  Future<void> saveConversation(Conversation conversation);
  
  /// Récupère toutes les conversations
  Future<List<Conversation>> getConversations();
  
  /// Récupère une conversation par son ID
  Future<Conversation?> getConversationById(String id);
  
  /// Supprime une conversation
  Future<void> deleteConversation(String id);
  
  /// Ajoute un message à une conversation
  Future<void> addMessageToConversation(String conversationId, Message message);
  
  /// Crée une nouvelle conversation
  Future<Conversation> createConversation(String title);
}

class ChatbotLocalSourceImpl implements ChatbotLocalSource {
  final SharedPreferences _sharedPreferences;
  
  // Clé pour stocker les conversations dans SharedPreferences
  static const String _conversationsStorageKey = 'conversations';
  
  ChatbotLocalSourceImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<void> saveConversation(Conversation conversation) async {
    final conversations = await getConversations();
    
    // Vérifier si la conversation existe déjà
    final index = conversations.indexWhere((c) => c.id == conversation.id);
    
    if (index >= 0) {
      // Mettre à jour la conversation existante
      conversations[index] = conversation;
    } else {
      // Ajouter la nouvelle conversation
      conversations.add(conversation);
    }
    
    // Sauvegarder les conversations
    await _saveConversations(conversations);
  }

  @override
  Future<List<Conversation>> getConversations() async {
    final String? conversationsJson = _sharedPreferences.getString(_conversationsStorageKey);
    
    if (conversationsJson == null || conversationsJson.isEmpty) {
      return [];
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(conversationsJson);
      return decoded.map((json) => Conversation.fromJson(json)).toList();
    } catch (e) {
      // En cas d'erreur, retourner une liste vide
      return [];
    }
  }

  @override
  Future<Conversation?> getConversationById(String id) async {
    final conversations = await getConversations();
    return conversations.firstWhere(
      (conversation) => conversation.id == id,
      orElse: () => null as Conversation, // Cette ligne génère une exception si aucune conversation n'est trouvée
    );
  }

  @override
  Future<void> deleteConversation(String id) async {
    final conversations = await getConversations();
    conversations.removeWhere((conversation) => conversation.id == id);
    await _saveConversations(conversations);
  }
  
  @override
  Future<void> addMessageToConversation(String conversationId, Message message) async {
    try {
      final conversations = await getConversations();
      final index = conversations.indexWhere((c) => c.id == conversationId);
      
      if (index < 0) {
        throw Exception('Conversation non trouvée');
      }
      
      final conversation = conversations[index];
      final messages = List<Message>.from(conversation.messages)..add(message);
      
      conversations[index] = conversation.copyWith(
        messages: messages,
        updatedAt: DateTime.now(),
      );
      
      await _saveConversations(conversations);
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du message: $e');
    }
  }
  
  @override
  Future<Conversation> createConversation(String title) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    
    final conversation = Conversation(
      id: id,
      title: title,
      messages: [],
      createdAt: now,
      updatedAt: now,
    );
    
    await saveConversation(conversation);
    return conversation;
  }
  
  /// Sauvegarde la liste des conversations
  Future<void> _saveConversations(List<Conversation> conversations) async {
    final String encodedConversations = jsonEncode(
      conversations.map((conversation) => conversation.toJson()).toList(),
    );
    
    await _sharedPreferences.setString(_conversationsStorageKey, encodedConversations);
  }
}
