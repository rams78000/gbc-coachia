import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chatbot_repository.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';

/// BLoC to handle chatbot functionality
class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  /// Chatbot repository
  final ChatbotRepository? chatbotRepository;

  /// Constructor
  ChatbotBloc({this.chatbotRepository}) : super(ChatbotInitial()) {
    on<LoadConversationsEvent>(_onLoadConversations);
    on<LoadConversationEvent>(_onLoadConversation);
    on<CreateConversationEvent>(_onCreateConversation);
    on<UpdateConversationEvent>(_onUpdateConversation);
    on<DeleteConversationEvent>(_onDeleteConversation);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkMessagesAsReadEvent>(_onMarkMessagesAsRead);
    on<GetSuggestedPromptsEvent>(_onGetSuggestedPrompts);
  }

  /// Handle loading all conversations
  Future<void> _onLoadConversations(
    LoadConversationsEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ChatbotLoading());
    
    try {
      // TODO: Replace with actual repository implementation
      final conversations = await Future.delayed(
        const Duration(milliseconds: 500),
        () => <Conversation>[],
      );
      
      emit(ConversationsLoaded(conversations: conversations));
    } catch (e) {
      emit(ChatbotError(message: 'Failed to load conversations'));
    }
  }

  /// Handle loading a single conversation
  Future<void> _onLoadConversation(
    LoadConversationEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ChatbotLoading());
    
    try {
      // TODO: Replace with actual repository implementation
      final conversation = await Future.delayed(
        const Duration(milliseconds: 500),
        () => null, // Simulate a conversation
      );
      
      if (conversation != null) {
        final suggestedPrompts = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <String>[],
        );
        
        emit(ConversationLoaded(
          conversation: conversation,
          suggestedPrompts: suggestedPrompts,
        ));
      } else {
        emit(ChatbotError(message: 'Conversation not found'));
      }
    } catch (e) {
      emit(ChatbotError(message: 'Failed to load conversation'));
    }
  }

  /// Handle creating a new conversation
  Future<void> _onCreateConversation(
    CreateConversationEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ChatbotLoading());
    
    try {
      // TODO: Replace with actual repository implementation
      final newConversation = await Future.delayed(
        const Duration(milliseconds: 500),
        () => null, // Simulate a new conversation
      );
      
      if (newConversation != null) {
        emit(ConversationLoaded(conversation: newConversation));
      } else {
        emit(ChatbotError(message: 'Failed to create conversation'));
      }
    } catch (e) {
      emit(ChatbotError(message: 'Failed to create conversation'));
    }
  }

  /// Handle updating a conversation
  Future<void> _onUpdateConversation(
    UpdateConversationEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    if (state is ConversationLoaded) {
      final currentState = state as ConversationLoaded;
      
      try {
        // TODO: Replace with actual repository implementation
        final updatedConversation = await Future.delayed(
          const Duration(milliseconds: 500),
          () => event.conversation,
        );
        
        emit(currentState.copyWith(conversation: updatedConversation));
      } catch (e) {
        emit(ChatbotError(message: 'Failed to update conversation'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle deleting a conversation
  Future<void> _onDeleteConversation(
    DeleteConversationEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    if (state is ConversationsLoaded) {
      final currentState = state as ConversationsLoaded;
      emit(ChatbotLoading());
      
      try {
        // TODO: Replace with actual repository implementation
        final success = await Future.delayed(
          const Duration(milliseconds: 500),
          () => true,
        );
        
        if (success) {
          final updatedConversations = currentState.conversations
              .where((conversation) => conversation.id != event.conversationId)
              .toList();
          emit(ConversationsLoaded(conversations: updatedConversations));
        } else {
          emit(ChatbotError(message: 'Failed to delete conversation'));
          emit(currentState); // Revert to previous state
        }
      } catch (e) {
        emit(ChatbotError(message: 'Failed to delete conversation'));
        emit(currentState); // Revert to previous state
      }
    }
  }

  /// Handle sending a message
  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    if (state is ConversationLoaded) {
      final currentState = state as ConversationLoaded;
      emit(currentState.copyWith(isSending: true));
      
      try {
        // Create user message
        final userMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: event.content,
          sender: MessageSender.user,
          timestamp: DateTime.now(),
          attachments: event.attachments,
          createdAt: DateTime.now(),
        );
        
        // Add user message to conversation
        final updatedMessages = List.of(currentState.conversation.messages)
          ..add(userMessage);
        
        final updatedConversation = currentState.conversation.copyWith(
          messages: updatedMessages,
          lastMessageTimestamp: userMessage.timestamp,
          updatedAt: DateTime.now(),
        );
        
        emit(currentState.copyWith(
          conversation: updatedConversation,
          isSending: true,
        ));
        
        // TODO: Replace with actual repository implementation
        final aiResponse = await Future.delayed(
          const Duration(seconds: 1),
          () => Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: "This is a placeholder AI response",
            sender: MessageSender.assistant,
            timestamp: DateTime.now(),
            createdAt: DateTime.now(),
          ),
        );
        
        // Add AI response to conversation
        final messagesWithResponse = List.of(updatedConversation.messages)
          ..add(aiResponse);
        
        final conversationWithResponse = updatedConversation.copyWith(
          messages: messagesWithResponse,
          lastMessageTimestamp: aiResponse.timestamp,
          updatedAt: DateTime.now(),
        );
        
        // Get updated suggested prompts
        final suggestedPrompts = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <String>[],
        );
        
        emit(currentState.copyWith(
          conversation: conversationWithResponse,
          suggestedPrompts: suggestedPrompts,
          isSending: false,
        ));
      } catch (e) {
        // Add error message to conversation
        final errorMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: "Sorry, there was an error processing your request.",
          sender: MessageSender.assistant,
          timestamp: DateTime.now(),
          isError: true,
          createdAt: DateTime.now(),
        );
        
        final updatedMessages = List.of(currentState.conversation.messages)
          ..add(errorMessage);
        
        final updatedConversation = currentState.conversation.copyWith(
          messages: updatedMessages,
          lastMessageTimestamp: errorMessage.timestamp,
          updatedAt: DateTime.now(),
        );
        
        emit(currentState.copyWith(
          conversation: updatedConversation,
          isSending: false,
        ));
        
        emit(ChatbotError(message: 'Failed to send message'));
      }
    }
  }

  /// Handle marking messages as read
  Future<void> _onMarkMessagesAsRead(
    MarkMessagesAsReadEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    if (state is ConversationLoaded) {
      final currentState = state as ConversationLoaded;
      
      try {
        // TODO: Replace with actual repository implementation
        final success = await Future.delayed(
          const Duration(milliseconds: 500),
          () => true,
        );
        
        if (success) {
          // Mark all messages as read
          final updatedMessages = currentState.conversation.messages
              .map((message) => message.copyWith(isRead: true))
              .toList();
          
          final updatedConversation = currentState.conversation.copyWith(
            messages: updatedMessages,
          );
          
          emit(currentState.copyWith(conversation: updatedConversation));
        }
      } catch (e) {
        // Don't emit error, just continue with current state
      }
    }
  }

  /// Handle getting suggested prompts
  Future<void> _onGetSuggestedPrompts(
    GetSuggestedPromptsEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    if (state is ConversationLoaded) {
      final currentState = state as ConversationLoaded;
      
      try {
        // TODO: Replace with actual repository implementation
        final suggestedPrompts = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <String>[],
        );
        
        emit(currentState.copyWith(suggestedPrompts: suggestedPrompts));
      } catch (e) {
        // Don't emit error, just continue with current state
      }
    } else {
      try {
        // TODO: Replace with actual repository implementation
        final suggestedPrompts = await Future.delayed(
          const Duration(milliseconds: 500),
          () => <String>[],
        );
        
        emit(SuggestedPromptsLoaded(
          prompts: suggestedPrompts,
          conversationId: event.conversationId,
        ));
      } catch (e) {
        emit(ChatbotError(message: 'Failed to get suggested prompts'));
      }
    }
  }
}
