import 'package:uuid/uuid.dart';

import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../sources/local_storage.dart';
import '../sources/openai_api.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotLocalStorage _localStorage;
  final OpenAIApi _openAIApi;
  final Uuid _uuid = const Uuid();

  ChatbotRepositoryImpl({
    required ChatbotLocalStorage localStorage,
    required OpenAIApi openAIApi,
  })  : _localStorage = localStorage,
        _openAIApi = openAIApi;

  @override
  Future<List<Conversation>> getConversations() async {
    return await _localStorage.getConversations();
  }

  @override
  Future<Conversation?> getConversationById(String id) async {
    try {
      return await _localStorage.getConversationById(id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Conversation> createConversation(String title) async {
    final now = DateTime.now();
    final conversation = Conversation(
      id: _uuid.v4(),
      title: title,
      messages: [],
      createdAt: now,
      lastUpdatedAt: now,
    );
    
    await _localStorage.saveConversation(conversation);
    return conversation;
  }

  @override
  Future<void> updateConversation(Conversation conversation) async {
    await _localStorage.saveConversation(conversation);
  }

  @override
  Future<void> deleteConversation(String id) async {
    await _localStorage.deleteConversation(id);
  }

  @override
  Future<Message> sendMessageToAI(Conversation conversation, String content) async {
    // Créer le message utilisateur
    final userMessage = Message(
      id: _uuid.v4(),
      content: content,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );
    
    // Ajouter le message utilisateur à la conversation
    final updatedConversation = conversation.addMessage(userMessage);
    await updateConversation(updatedConversation);
    
    try {
      // Envoyer la conversation à l'API OpenAI et récupérer la réponse
      final assistantMessage = await _openAIApi.sendMessage(updatedConversation);
      
      // Ajouter la réponse de l'IA à la conversation
      final finalConversation = updatedConversation.addMessage(assistantMessage);
      await updateConversation(finalConversation);
      
      return assistantMessage;
    } catch (e) {
      // Gérer les erreurs
      final errorMessage = Message(
        id: _uuid.v4(),
        content: "Désolé, je n'ai pas pu obtenir de réponse. Erreur: $e",
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );
      
      // Ajouter le message d'erreur à la conversation
      final errorConversation = updatedConversation.addMessage(errorMessage);
      await updateConversation(errorConversation);
      
      return errorMessage;
    }
  }
}
