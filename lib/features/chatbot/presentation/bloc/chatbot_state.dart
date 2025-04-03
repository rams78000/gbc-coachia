part of 'chatbot_bloc.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();
  
  @override
  List<Object> get props => [];
}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotConversationLoaded extends ChatbotState {
  final String conversationId;
  final List<Map<String, dynamic>> messages;
  final bool isLoading;
  
  const ChatbotConversationLoaded({
    required this.conversationId,
    required this.messages,
    this.isLoading = false,
  });
  
  @override
  List<Object> get props => [conversationId, messages, isLoading];
}

class ChatbotConversationsLoaded extends ChatbotState {
  final List<Map<String, dynamic>> conversations;
  
  const ChatbotConversationsLoaded({required this.conversations});
  
  @override
  List<Object> get props => [conversations];
}

class ChatbotError extends ChatbotState {
  final String message;
  
  const ChatbotError(this.message);
  
  @override
  List<Object> get props => [message];
}
