import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/repositories/chatbot_repository.dart';

part 'chatbot_event.dart';
part 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotRepository chatbotRepository;
  
  ChatbotBloc({required this.chatbotRepository}) : super(ChatbotInitial()) {
    on<SendMessage>(_onSendMessage);
    on<LoadConversation>(_onLoadConversation);
    on<CreateConversation>(_onCreateConversation);
    on<LoadConversations>(_onLoadConversations);
    on<DeleteConversation>(_onDeleteConversation);
    on<UpdateConversationTitle>(_onUpdateConversationTitle);
  }
  
  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatbotState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is ChatbotConversationLoaded) {
      // Add user message to UI immediately
      final updatedMessages = List<Map<String, dynamic>>.from(currentState.messages);
      updatedMessages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'content': event.message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'role': 'user',
      });
      
      emit(ChatbotConversationLoaded(
        conversationId: currentState.conversationId,
        messages: updatedMessages,
        isLoading: true,
      ));
      
      try {
        // Send message to repository and get response
        final response = await chatbotRepository.sendMessage(
          message: event.message,
          conversationId: currentState.conversationId,
        );
        
        // Add response to UI
        updatedMessages.add(response);
        
        emit(ChatbotConversationLoaded(
          conversationId: currentState.conversationId,
          messages: updatedMessages,
          isLoading: false,
        ));
      } catch (e) {
        emit(ChatbotError('Failed to send message: ${e.toString()}'));
        emit(ChatbotConversationLoaded(
          conversationId: currentState.conversationId,
          messages: updatedMessages,
          isLoading: false,
        ));
      }
    }
  }
  
  Future<void> _onLoadConversation(
    LoadConversation event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ChatbotLoading());
    
    try {
      final messages = await chatbotRepository.getConversationHistory(
        conversationId: event.conversationId,
      );
      
      emit(ChatbotConversationLoaded(
        conversationId: event.conversationId,
        messages: messages,
        isLoading: false,
      ));
    } catch (e) {
      emit(ChatbotError('Failed to load conversation: ${e.toString()}'));
    }
  }
  
  Future<void> _onCreateConversation(
    CreateConversation event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ChatbotLoading());
    
    try {
      final conversationId = await chatbotRepository.createConversation(
        title: event.title,
      );
      
      emit(ChatbotConversationLoaded(
        conversationId: conversationId,
        messages: [],
        isLoading: false,
      ));
    } catch (e) {
      emit(ChatbotError('Failed to create conversation: ${e.toString()}'));
    }
  }
  
  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ChatbotLoading());
    
    try {
      final conversations = await chatbotRepository.getConversations();
      
      emit(ChatbotConversationsLoaded(conversations: conversations));
    } catch (e) {
      emit(ChatbotError('Failed to load conversations: ${e.toString()}'));
    }
  }
  
  Future<void> _onDeleteConversation(
    DeleteConversation event,
    Emitter<ChatbotState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is ChatbotConversationsLoaded) {
      emit(ChatbotLoading());
      
      try {
        final success = await chatbotRepository.deleteConversation(
          conversationId: event.conversationId,
        );
        
        if (success) {
          final updatedConversations = await chatbotRepository.getConversations();
          emit(ChatbotConversationsLoaded(conversations: updatedConversations));
        } else {
          emit(ChatbotError('Failed to delete conversation'));
          emit(currentState);
        }
      } catch (e) {
        emit(ChatbotError('Failed to delete conversation: ${e.toString()}'));
        emit(currentState);
      }
    }
  }
  
  Future<void> _onUpdateConversationTitle(
    UpdateConversationTitle event,
    Emitter<ChatbotState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is ChatbotConversationsLoaded) {
      try {
        final success = await chatbotRepository.updateConversationTitle(
          conversationId: event.conversationId,
          title: event.title,
        );
        
        if (success) {
          final updatedConversations = await chatbotRepository.getConversations();
          emit(ChatbotConversationsLoaded(conversations: updatedConversations));
        }
      } catch (e) {
        emit(ChatbotError('Failed to update conversation title: ${e.toString()}'));
        emit(currentState);
      }
    }
  }
}
