import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/conversation.dart';

class ChatbotLocalStorage {
  final SharedPreferences _preferences;
  static const String _conversationsKey = 'chatbot_conversations';

  ChatbotLocalStorage({required SharedPreferences preferences})
      : _preferences = preferences;

  // Récupérer toutes les conversations depuis le stockage local
  Future<List<Conversation>> getConversations() async {
    final String? conversationsJson = _preferences.getString(_conversationsKey);
    
    if (conversationsJson == null) {
      return [];
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(conversationsJson) as List<dynamic>;
      return decoded
          .map((json) => Conversation.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // En cas d'erreur, retourner une liste vide
      return [];
    }
  }

  // Sauvegarder toutes les conversations dans le stockage local
  Future<void> saveConversations(List<Conversation> conversations) async {
    final List<Map<String, dynamic>> conversationsJson = 
        conversations.map((c) => c.toJson()).toList();
    
    await _preferences.setString(_conversationsKey, jsonEncode(conversationsJson));
  }

  // Récupérer une conversation par son ID
  Future<Conversation?> getConversationById(String id) async {
    final conversations = await getConversations();
    return conversations.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Conversation non trouvée: $id'),
    );
  }

  // Ajouter ou mettre à jour une conversation
  Future<void> saveConversation(Conversation conversation) async {
    final conversations = await getConversations();
    
    // Vérifier si la conversation existe déjà
    final index = conversations.indexWhere((c) => c.id == conversation.id);
    
    if (index >= 0) {
      // Mettre à jour la conversation existante
      conversations[index] = conversation;
    } else {
      // Ajouter une nouvelle conversation
      conversations.add(conversation);
    }
    
    await saveConversations(conversations);
  }

  // Supprimer une conversation
  Future<void> deleteConversation(String id) async {
    final conversations = await getConversations();
    final filteredConversations = conversations.where((c) => c.id != id).toList();
    await saveConversations(filteredConversations);
  }
}
