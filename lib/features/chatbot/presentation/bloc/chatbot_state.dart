import 'package:equatable/equatable.dart';

import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';

/// Abstract class for Chatbot states
abstract class ChatbotState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state of chatbot
class ChatbotInitial extends ChatbotState {}

/// State for loading chatbot data
class ChatbotLoading extends ChatbotState {}

/// State for conversations loaded
class ConversationsLoaded extends ChatbotState {
  /// List of conversations
  final List<Conversation> conversations;

  /// Constructor
  ConversationsLoaded({required this.conversations});

  @override
  List<Object> get props => [conversations];
}

/// State for a single conversation loaded
class ConversationLoaded extends ChatbotState {
  /// Current conversation
  final Conversation conversation;
  
  /// Suggested prompts
  final List<String> suggestedPrompts;
  
  /// Is sending message
  final bool isSending;

  /// Constructor
  ConversationLoaded({
    required this.conversation,
    this.suggestedPrompts = const [],
    this.isSending = false,
  });

  @override
  List<Object> get props => [
    conversation,
    suggestedPrompts,
    isSending,
  ];

  /// Create a copy with updated fields
  ConversationLoaded copyWith({
    Conversation? conversation,
    List<String>? suggestedPrompts,
    bool? isSending,
  }) {
    return ConversationLoaded(
      conversation: conversation ?? this.conversation,
      suggestedPrompts: suggestedPrompts ?? this.suggestedPrompts,
      isSending: isSending ?? this.isSending,
    );
  }
}

/// State for message sending in progress
class MessageSending extends ChatbotState {}

/// State for suggested prompts loaded
class SuggestedPromptsLoaded extends ChatbotState {
  /// Suggested prompts
  final List<String> prompts;
  
  /// Conversation ID
  final String conversationId;

  /// Constructor
  SuggestedPromptsLoaded({
    required this.prompts,
    required this.conversationId,
  });

  @override
  List<Object> get props => [prompts, conversationId];
}

/// State for error in chatbot functionality
class ChatbotError extends ChatbotState {
  /// Error message
  final String message;

  /// Constructor
  ChatbotError({required this.message});

  @override
  List<Object> get props => [message];
}
