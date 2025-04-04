part of 'chatbot_bloc.dart';

@immutable
abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object?> get props => [];
}

/// Événement pour charger toutes les conversations
class LoadConversations extends ChatbotEvent {
  const LoadConversations();
}

/// Événement pour charger le détail d'une conversation
class LoadConversationDetail extends ChatbotEvent {
  final String conversationId;

  const LoadConversationDetail({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

/// Événement pour créer une nouvelle conversation
class CreateConversation extends ChatbotEvent {
  final String title;

  const CreateConversation({required this.title});

  @override
  List<Object?> get props => [title];
}

/// Événement pour supprimer une conversation
class DeleteConversation extends ChatbotEvent {
  final String conversationId;

  const DeleteConversation({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

/// Événement pour envoyer un message dans une conversation
class SendMessage extends ChatbotEvent {
  final String conversationId;
  final String content;
  final bool useFeatures;

  const SendMessage({
    required this.conversationId,
    required this.content,
    this.useFeatures = true,
  });

  @override
  List<Object?> get props => [conversationId, content, useFeatures];
}

/// Événement pour vérifier si la clé API est valide
class CheckApiKey extends ChatbotEvent {
  const CheckApiKey();
}

/// Événement pour définir la clé API
class SetApiKey extends ChatbotEvent {
  final String apiKey;

  const SetApiKey({required this.apiKey});

  @override
  List<Object?> get props => [apiKey];
}
