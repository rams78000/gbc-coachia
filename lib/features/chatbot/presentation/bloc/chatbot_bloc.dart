import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chatbot_repository.dart';

part 'chatbot_event.dart';
part 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotRepository _chatbotRepository;

  ChatbotBloc({required ChatbotRepository chatbotRepository})
      : _chatbotRepository = chatbotRepository,
        super(ChatbotInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<LoadConversationDetail>(_onLoadConversationDetail);
    on<CreateConversation>(_onCreateConversation);
    on<DeleteConversation>(_onDeleteConversation);
    on<SendMessage>(_onSendMessage);
    on<CheckApiKey>(_onCheckApiKey);
    on<SetApiKey>(_onSetApiKey);
  }

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ConversationsLoading());
    try {
      final conversations = await _chatbotRepository.getConversations();
      emit(ConversationsLoaded(conversations: conversations));
    } catch (e) {
      emit(ChatbotError(message: e.toString()));
    }
  }

  Future<void> _onLoadConversationDetail(
    LoadConversationDetail event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ConversationDetailLoading());
    try {
      final conversation = await _chatbotRepository.getConversationById(event.conversationId);
      if (conversation != null) {
        emit(ConversationDetailLoaded(conversation: conversation));
      } else {
        emit(const ChatbotError(message: 'Conversation introuvable'));
      }
    } catch (e) {
      emit(ChatbotError(message: e.toString()));
    }
  }

  Future<void> _onCreateConversation(
    CreateConversation event,
    Emitter<ChatbotState> emit,
  ) async {
    try {
      final newConversation = await _chatbotRepository.createConversation(event.title);
      
      // Si nous sommes en train d'afficher la liste des conversations, mettons-la à jour
      if (state is ConversationsLoaded) {
        final currentConversations = (state as ConversationsLoaded).conversations;
        emit(ConversationsLoaded(
          conversations: [...currentConversations, newConversation],
        ));
      }
      
      // Émettre un état indiquant que la conversation a été créée avec succès
      emit(ConversationCreated(conversation: newConversation));
    } catch (e) {
      emit(ChatbotError(message: e.toString()));
    }
  }

  Future<void> _onDeleteConversation(
    DeleteConversation event,
    Emitter<ChatbotState> emit,
  ) async {
    try {
      await _chatbotRepository.deleteConversation(event.conversationId);
      
      // Si nous sommes en train d'afficher la liste des conversations, mettons-la à jour
      if (state is ConversationsLoaded) {
        final currentConversations = (state as ConversationsLoaded).conversations;
        emit(ConversationsLoaded(
          conversations: currentConversations
              .where((c) => c.id != event.conversationId)
              .toList(),
        ));
      }
      
      // Émettre un état indiquant que la conversation a été supprimée avec succès
      emit(ConversationDeleted(conversationId: event.conversationId));
    } catch (e) {
      emit(ChatbotError(message: e.toString()));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatbotState> emit,
  ) async {
    // Vérifier si la clé API est valide avant d'envoyer le message
    try {
      final isApiKeyValid = await _chatbotRepository.isApiKeyValid();
      if (!isApiKeyValid) {
        emit(ApiKeyInvalid());
        return;
      }
    } catch (e) {
      emit(ApiKeyInvalid());
      return;
    }

    // Sauvegarder l'état actuel pour y revenir après
    final currentState = state;
    
    // Indiquer que nous sommes en train d'envoyer un message
    if (currentState is ConversationDetailLoaded) {
      emit(ConversationMessageSending(conversation: currentState.conversation));
    }
    
    try {
      final aiResponse = await _chatbotRepository.sendMessage(
        event.conversationId,
        event.content,
        useFeatures: event.useFeatures,
      );
      
      // Charger la conversation mise à jour
      final updatedConversation = await _chatbotRepository.getConversationById(event.conversationId);
      
      if (updatedConversation != null) {
        emit(ConversationDetailLoaded(conversation: updatedConversation));
      } else {
        emit(const ChatbotError(message: 'Conversation introuvable après envoi du message'));
      }
    } catch (e) {
      // En cas d'erreur, revenir à l'état précédent si possible
      if (currentState is ConversationDetailLoaded) {
        emit(ConversationDetailLoaded(conversation: currentState.conversation));
      }
      emit(ChatbotError(message: e.toString()));
    }
  }

  Future<void> _onCheckApiKey(
    CheckApiKey event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ApiKeyChecking());
    try {
      final isValid = await _chatbotRepository.isApiKeyValid();
      if (isValid) {
        emit(ApiKeyValid());
      } else {
        emit(ApiKeyInvalid());
      }
    } catch (e) {
      emit(ApiKeyInvalid());
    }
  }

  Future<void> _onSetApiKey(
    SetApiKey event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ApiKeyUpdating());
    try {
      await _chatbotRepository.setApiKey(event.apiKey);
      final isValid = await _chatbotRepository.isApiKeyValid();
      
      if (isValid) {
        emit(ApiKeyValid());
      } else {
        emit(ApiKeyInvalid());
      }
    } catch (e) {
      emit(ChatbotError(message: e.toString()));
    }
  }
}
