part of 'chatbot_bloc.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object> get props => [];
}

class SendMessage extends ChatbotEvent {
  final String message;
  
  const SendMessage({required this.message});
  
  @override
  List<Object> get props => [message];
}

class LoadConversation extends ChatbotEvent {
  final String conversationId;
  
  const LoadConversation({required this.conversationId});
  
  @override
  List<Object> get props => [conversationId];
}

class CreateConversation extends ChatbotEvent {
  final String? title;
  
  const CreateConversation({this.title});
  
  @override
  List<Object> get props => title != null ? [title!] : [];
}

class LoadConversations extends ChatbotEvent {}

class DeleteConversation extends ChatbotEvent {
  final String conversationId;
  
  const DeleteConversation({required this.conversationId});
  
  @override
  List<Object> get props => [conversationId];
}

class UpdateConversationTitle extends ChatbotEvent {
  final String conversationId;
  final String title;
  
  const UpdateConversationTitle({
    required this.conversationId,
    required this.title,
  });
  
  @override
  List<Object> get props => [conversationId, title];
}
