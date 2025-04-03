import 'package:equatable/equatable.dart';

import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';

/// Abstract class for Chatbot events
abstract class ChatbotEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to load all conversations
class LoadConversationsEvent extends ChatbotEvent {}

/// Event to load a single conversation
class LoadConversationEvent extends ChatbotEvent {
  /// Conversation ID
  final String conversationId;

  /// Constructor
  LoadConversationEvent({required this.conversationId});

  @override
  List<Object> get props => [conversationId];
}

/// Event to create a new conversation
class CreateConversationEvent extends ChatbotEvent {
  /// Conversation title
  final String title;

  /// Constructor
  CreateConversationEvent({required this.title});

  @override
  List<Object> get props => [title];
}

/// Event to update a conversation
class UpdateConversationEvent extends ChatbotEvent {
  /// Conversation to update
  final Conversation conversation;

  /// Constructor
  UpdateConversationEvent({required this.conversation});

  @override
  List<Object> get props => [conversation];
}

/// Event to delete a conversation
class DeleteConversationEvent extends ChatbotEvent {
  /// Conversation ID to delete
  final String conversationId;

  /// Constructor
  DeleteConversationEvent({required this.conversationId});

  @override
  List<Object> get props => [conversationId];
}

/// Event to send a message
class SendMessageEvent extends ChatbotEvent {
  /// Conversation ID
  final String conversationId;
  
  /// Message content
  final String content;
  
  /// Attachments
  final List<String> attachments;

  /// Constructor
  SendMessageEvent({
    required this.conversationId,
    required this.content,
    this.attachments = const [],
  });

  @override
  List<Object> get props => [conversationId, content, attachments];
}

/// Event to mark messages as read
class MarkMessagesAsReadEvent extends ChatbotEvent {
  /// Conversation ID
  final String conversationId;

  /// Constructor
  MarkMessagesAsReadEvent({required this.conversationId});

  @override
  List<Object> get props => [conversationId];
}

/// Event to get suggested prompts
class GetSuggestedPromptsEvent extends ChatbotEvent {
  /// Conversation ID
  final String conversationId;

  /// Constructor
  GetSuggestedPromptsEvent({required this.conversationId});

  @override
  List<Object> get props => [conversationId];
}
