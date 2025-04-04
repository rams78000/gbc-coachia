import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/chatbot_repository.dart';

/// Événements pour le bloc chatbot
abstract class ChatbotEvent extends Equatable {
  /// Constructeur
  const ChatbotEvent();

  @override
  List<Object> get props => [];
}

/// Événement pour charger l'historique des conversations
class LoadConversation extends ChatbotEvent {
  /// Constructeur
  const LoadConversation();
}

/// Événement pour envoyer un message à l'IA
class SendMessage extends ChatbotEvent {
  /// Contenu du message
  final String message;

  /// Constructeur
  const SendMessage({required this.message});

  @override
  List<Object> get props => [message];
}

/// Événement pour effacer l'historique
class ClearConversation extends ChatbotEvent {
  /// Constructeur
  const ClearConversation();
}

/// États pour le bloc chatbot
abstract class ChatbotState extends Equatable {
  /// Constructeur
  const ChatbotState();

  @override
  List<Object> get props => [];
}

/// État initial du chatbot
class ChatbotInitial extends ChatbotState {}

/// État de chargement des messages
class ChatbotLoading extends ChatbotState {}

/// État lorsque les messages sont chargés
class ChatbotLoaded extends ChatbotState {
  /// Liste des messages de la conversation
  final List<ChatMessage> messages;

  /// Constructeur
  const ChatbotLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

/// État d'erreur du chatbot
class ChatbotError extends ChatbotState {
  /// Message d'erreur
  final String message;

  /// Constructeur
  const ChatbotError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Bloc gérant le chatbot
class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotRepository _chatbotRepository;

  /// Constructeur
  ChatbotBloc({required ChatbotRepository chatbotRepository})
      : _chatbotRepository = chatbotRepository,
        super(ChatbotInitial()) {
    on<LoadConversation>(_onLoadConversation);
    on<SendMessage>(_onSendMessage);
    on<ClearConversation>(_onClearConversation);
  }

  Future<void> _onLoadConversation(
    LoadConversation event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ChatbotLoading());
    try {
      final messages = await _chatbotRepository.getConversationHistory();
      emit(ChatbotLoaded(messages: messages));
    } catch (e) {
      emit(ChatbotError(message: e.toString()));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatbotState> emit,
  ) async {
    if (state is ChatbotLoaded) {
      // Garder les messages actuels pendant le traitement
      final currentMessages = (state as ChatbotLoaded).messages;
      try {
        // Envoyer le message et récupérer la réponse
        await _chatbotRepository.sendMessage(event.message);
        
        // Rafraîchir la liste des messages
        final updatedMessages = await _chatbotRepository.getConversationHistory();
        emit(ChatbotLoaded(messages: updatedMessages));
      } catch (e) {
        emit(ChatbotError(message: e.toString()));
      }
    }
  }

  Future<void> _onClearConversation(
    ClearConversation event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ChatbotLoading());
    try {
      await _chatbotRepository.clearConversationHistory();
      emit(const ChatbotLoaded(messages: []));
    } catch (e) {
      emit(ChatbotError(message: e.toString()));
    }
  }
}
