part of 'chatbot_bloc.dart';

@immutable
abstract class ChatbotState extends Equatable {
  const ChatbotState();
  
  @override
  List<Object?> get props => [];
}

/// État initial
class ChatbotInitial extends ChatbotState {}

/// État indiquant que les conversations sont en cours de chargement
class ConversationsLoading extends ChatbotState {}

/// État indiquant que les conversations ont été chargées
class ConversationsLoaded extends ChatbotState {
  final List<Conversation> conversations;

  const ConversationsLoaded({required this.conversations});

  @override
  List<Object?> get props => [conversations];
}

/// État indiquant qu'une conversation est en cours de chargement
class ConversationDetailLoading extends ChatbotState {}

/// État indiquant qu'une conversation a été chargée
class ConversationDetailLoaded extends ChatbotState {
  final Conversation conversation;

  const ConversationDetailLoaded({required this.conversation});

  @override
  List<Object?> get props => [conversation];
}

/// État indiquant qu'une conversation a été créée
class ConversationCreated extends ChatbotState {
  final Conversation conversation;

  const ConversationCreated({required this.conversation});

  @override
  List<Object?> get props => [conversation];
}

/// État indiquant qu'une conversation a été supprimée
class ConversationDeleted extends ChatbotState {
  final String conversationId;

  const ConversationDeleted({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

/// État indiquant qu'un message est en cours d'envoi
class ConversationMessageSending extends ChatbotState {
  final Conversation conversation;

  const ConversationMessageSending({required this.conversation});

  @override
  List<Object?> get props => [conversation];
}

/// État indiquant qu'une erreur s'est produite
class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// État indiquant que la clé API est en cours de vérification
class ApiKeyChecking extends ChatbotState {}

/// État indiquant que la clé API est valide
class ApiKeyValid extends ChatbotState {}

/// État indiquant que la clé API est invalide
class ApiKeyInvalid extends ChatbotState {}

/// État indiquant que la clé API est en cours de mise à jour
class ApiKeyUpdating extends ChatbotState {}
