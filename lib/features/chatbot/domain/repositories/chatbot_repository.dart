/// Interface pour le repository du chatbot
abstract class ChatbotRepository {
  /// Envoie un message à l'IA et récupère la réponse
  Future<String> sendMessage(String message);

  /// Récupère l'historique des conversations
  Future<List<ChatMessage>> getConversationHistory();

  /// Efface l'historique des conversations
  Future<void> clearConversationHistory();
}

/// Classe représentant un message dans la conversation
class ChatMessage {
  /// ID unique du message
  final String id;

  /// Contenu du message
  final String content;

  /// Date d'envoi du message
  final DateTime timestamp;

  /// Indique si le message est envoyé par l'utilisateur (true) ou l'IA (false)
  final bool isUserMessage;

  /// Constructeur
  ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isUserMessage,
  });
}
