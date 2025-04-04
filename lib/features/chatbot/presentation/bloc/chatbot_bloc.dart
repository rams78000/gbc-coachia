import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chatbot_repository.dart';

// Events
abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object> get props => [];
}

class ChatbotLoadConversations extends ChatbotEvent {
  const ChatbotLoadConversations();
}

class ChatbotCreateConversation extends ChatbotEvent {
  final String title;

  const ChatbotCreateConversation(this.title);

  @override
  List<Object> get props => [title];
}

class ChatbotLoadConversation extends ChatbotEvent {
  final String conversationId;

  const ChatbotLoadConversation(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class ChatbotSendMessage extends ChatbotEvent {
  final String content;

  const ChatbotSendMessage(this.content);

  @override
  List<Object> get props => [content];
}

class ChatbotDeleteConversation extends ChatbotEvent {
  final String conversationId;

  const ChatbotDeleteConversation(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

// States
abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {
  const ChatbotInitial();
}

class ChatbotLoading extends ChatbotState {
  const ChatbotLoading();
}

class ChatbotConversationsLoaded extends ChatbotState {
  final List<Conversation> conversations;

  const ChatbotConversationsLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ChatbotConversationLoaded extends ChatbotState {
  final Conversation conversation;
  final bool isProcessing;

  const ChatbotConversationLoaded(this.conversation, {this.isProcessing = false});

  @override
  List<Object?> get props => [conversation, isProcessing];

  ChatbotConversationLoaded copyWith({
    Conversation? conversation,
    bool? isProcessing,
  }) {
    return ChatbotConversationLoaded(
      conversation ?? this.conversation,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotRepository _repository;
  final Uuid _uuid = const Uuid();

  ChatbotBloc({required ChatbotRepository repository})
      : _repository = repository,
        super(const ChatbotInitial()) {
    on<ChatbotLoadConversations>(_onLoadConversations);
    on<ChatbotCreateConversation>(_onCreateConversation);
    on<ChatbotLoadConversation>(_onLoadConversation);
    on<ChatbotSendMessage>(_onSendMessage);
    on<ChatbotDeleteConversation>(_onDeleteConversation);
  }

  Future<void> _onLoadConversations(
    ChatbotLoadConversations event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(const ChatbotLoading());

    try {
      final conversations = await _repository.getConversations();
      emit(ChatbotConversationsLoaded(conversations));
    } catch (e) {
      emit(ChatbotError('Erreur lors du chargement des conversations: $e'));
    }
  }

  Future<void> _onCreateConversation(
    ChatbotCreateConversation event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(const ChatbotLoading());

    try {
      final conversation = await _repository.createConversation(event.title);
      emit(ChatbotConversationLoaded(conversation));
    } catch (e) {
      emit(ChatbotError('Erreur lors de la création de la conversation: $e'));
    }
  }

  Future<void> _onLoadConversation(
    ChatbotLoadConversation event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(const ChatbotLoading());

    try {
      final conversation = await _repository.getConversationById(event.conversationId);
      
      if (conversation != null) {
        emit(ChatbotConversationLoaded(conversation));
      } else {
        emit(const ChatbotError('Conversation non trouvée'));
      }
    } catch (e) {
      emit(ChatbotError('Erreur lors du chargement de la conversation: $e'));
    }
  }

  Future<void> _onSendMessage(
    ChatbotSendMessage event,
    Emitter<ChatbotState> emit,
  ) async {
    // Vérifier si nous sommes dans l'état de conversation chargée
    if (state is! ChatbotConversationLoaded) {
      emit(const ChatbotError('Aucune conversation active'));
      return;
    }

    final currentState = state as ChatbotConversationLoaded;
    final conversation = currentState.conversation;
    
    // Indiquer que le message est en cours de traitement
    emit(currentState.copyWith(isProcessing: true));

    try {
      // Envoyer le message à l'AI via le repository
      await _repository.sendMessageToAI(conversation, event.content);
      
      // Recharger la conversation mise à jour
      final updatedConversation = await _repository.getConversationById(conversation.id);
      
      if (updatedConversation != null) {
        emit(ChatbotConversationLoaded(updatedConversation));
      } else {
        emit(const ChatbotError('Conversation non trouvée après envoi du message'));
      }
    } catch (e) {
      emit(ChatbotError('Erreur lors de l\'envoi du message: $e'));
    }
  }

  Future<void> _onDeleteConversation(
    ChatbotDeleteConversation event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(const ChatbotLoading());

    try {
      await _repository.deleteConversation(event.conversationId);
      add(const ChatbotLoadConversations());
    } catch (e) {
      emit(ChatbotError('Erreur lors de la suppression de la conversation: $e'));
    }
  }
}
