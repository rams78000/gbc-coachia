import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../domain/entities/message.dart';

// Events
abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object> get props => [];
}

class ChatbotInitialized extends ChatbotEvent {
  const ChatbotInitialized();
}

class ChatbotMessageSent extends ChatbotEvent {
  final String content;

  const ChatbotMessageSent({required this.content});

  @override
  List<Object> get props => [content];
}

class ChatbotConversationCleared extends ChatbotEvent {
  const ChatbotConversationCleared();
}

// States
abstract class ChatbotState extends Equatable {
  const ChatbotState();
  
  @override
  List<Object> get props => [];
}

class ChatbotInitial extends ChatbotState {
  const ChatbotInitial();
}

class ChatbotLoading extends ChatbotState {
  const ChatbotLoading();
}

class ChatbotLoaded extends ChatbotState {
  final List<Message> messages;
  final bool isWaitingForResponse;

  const ChatbotLoaded({
    required this.messages,
    this.isWaitingForResponse = false,
  });

  ChatbotLoaded copyWith({
    List<Message>? messages,
    bool? isWaitingForResponse,
  }) {
    return ChatbotLoaded(
      messages: messages ?? this.messages,
      isWaitingForResponse: isWaitingForResponse ?? this.isWaitingForResponse,
    );
  }

  @override
  List<Object> get props => [messages, isWaitingForResponse];
}

class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final SharedPreferences _preferences;
  static const String _messagesKey = 'chatbot_messages';
  final Uuid _uuid = const Uuid();

  ChatbotBloc({required SharedPreferences preferences}) 
      : _preferences = preferences,
        super(const ChatbotInitial()) {
    on<ChatbotInitialized>(_onInitialized);
    on<ChatbotMessageSent>(_onMessageSent);
    on<ChatbotConversationCleared>(_onConversationCleared);
  }

  Future<void> _onInitialized(
    ChatbotInitialized event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(const ChatbotLoading());

    try {
      final messages = _loadMessages();
      
      if (messages.isEmpty) {
        // Ajouter un message de bienvenue initial
        final welcomeMessage = Message(
          id: _uuid.v4(),
          content: 'Bonjour ! Je suis votre assistant IA GBC CoachIA. Comment puis-je vous aider aujourd\'hui ?',
          isUserMessage: false,
          timestamp: DateTime.now(),
        );
        
        messages.add(welcomeMessage);
        _saveMessages(messages);
      }
      
      emit(ChatbotLoaded(messages: messages));
    } catch (e) {
      emit(ChatbotError(message: 'Erreur lors du chargement des messages: $e'));
    }
  }

  Future<void> _onMessageSent(
    ChatbotMessageSent event,
    Emitter<ChatbotState> emit,
  ) async {
    if (state is ChatbotLoaded) {
      final currentState = state as ChatbotLoaded;
      
      // Ajouter le message de l'utilisateur
      final userMessage = Message(
        id: _uuid.v4(),
        content: event.content,
        isUserMessage: true,
        timestamp: DateTime.now(),
      );
      
      final updatedMessages = List<Message>.from(currentState.messages)..add(userMessage);
      
      // Mettre à jour l'état pour montrer l'indicateur de chargement
      emit(currentState.copyWith(
        messages: updatedMessages,
        isWaitingForResponse: true,
      ));
      
      // Sauvegarder les messages
      _saveMessages(updatedMessages);
      
      // Simuler une réponse du chatbot (à remplacer par une API réelle)
      await Future.delayed(const Duration(seconds: 1));
      
      final botResponse = _generateBotResponse(event.content);
      final botMessage = Message(
        id: _uuid.v4(),
        content: botResponse,
        isUserMessage: false,
        timestamp: DateTime.now(),
      );
      
      final messagesWithBotResponse = List<Message>.from(updatedMessages)..add(botMessage);
      
      // Mettre à jour l'état avec la réponse du bot
      emit(currentState.copyWith(
        messages: messagesWithBotResponse,
        isWaitingForResponse: false,
      ));
      
      // Sauvegarder les messages incluant la réponse du bot
      _saveMessages(messagesWithBotResponse);
    }
  }

  Future<void> _onConversationCleared(
    ChatbotConversationCleared event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(const ChatbotLoading());
    
    try {
      // Supprimer tous les messages sauf le message de bienvenue
      final welcomeMessage = Message(
        id: _uuid.v4(),
        content: 'Bonjour ! Je suis votre assistant IA GBC CoachIA. Comment puis-je vous aider aujourd\'hui ?',
        isUserMessage: false,
        timestamp: DateTime.now(),
      );
      
      final messages = [welcomeMessage];
      _saveMessages(messages);
      
      emit(ChatbotLoaded(messages: messages));
    } catch (e) {
      emit(ChatbotError(message: 'Erreur lors de la suppression des messages: $e'));
    }
  }

  List<Message> _loadMessages() {
    final messagesJson = _preferences.getStringList(_messagesKey) ?? [];
    
    if (messagesJson.isEmpty) {
      return [];
    }
    
    return messagesJson.map((messageStr) {
      final messageMap = jsonDecode(messageStr) as Map<String, dynamic>;
      return Message(
        id: messageMap['id'] as String,
        content: messageMap['content'] as String,
        isUserMessage: messageMap['isUserMessage'] as bool,
        timestamp: DateTime.parse(messageMap['timestamp'] as String),
      );
    }).toList();
  }

  void _saveMessages(List<Message> messages) {
    final messagesJson = messages.map((message) {
      return jsonEncode({
        'id': message.id,
        'content': message.content,
        'isUserMessage': message.isUserMessage,
        'timestamp': message.timestamp.toIso8601String(),
      });
    }).toList();
    
    _preferences.setStringList(_messagesKey, messagesJson);
  }

  String _generateBotResponse(String userMessage) {
    // Simuler différentes réponses basées sur le message de l'utilisateur
    final lowerCaseMessage = userMessage.toLowerCase();
    
    if (lowerCaseMessage.contains('bonjour') || 
        lowerCaseMessage.contains('salut') || 
        lowerCaseMessage.contains('hello')) {
      return 'Bonjour ! Comment puis-je vous aider avec votre entreprise aujourd\'hui ?';
    } else if (lowerCaseMessage.contains('facture') || 
               lowerCaseMessage.contains('facturation')) {
      return 'Pour créer une nouvelle facture, allez dans la section Finance et cliquez sur "Nouvelle facture". Vous pouvez y ajouter vos services, définir les conditions de paiement et l\'envoyer directement à votre client.';
    } else if (lowerCaseMessage.contains('client') || 
               lowerCaseMessage.contains('prospect')) {
      return 'La gestion de la relation client est essentielle. Je vous suggère de maintenir un contact régulier avec vos clients et de noter leurs préférences dans la section Clients.';
    } else if (lowerCaseMessage.contains('conseil') || 
               lowerCaseMessage.contains('astuce')) {
      return 'Voici un conseil pour les entrepreneurs : bloquez du temps dans votre calendrier pour les tâches importantes mais non urgentes comme la planification stratégique et le développement personnel.';
    } else if (lowerCaseMessage.contains('merci')) {
      return 'Je vous en prie ! N\'hésitez pas si vous avez d\'autres questions.';
    } else {
      return 'Je comprends. Pour vous aider plus efficacement, pourriez-vous me donner plus de détails sur votre question concernant votre activité professionnelle ?';
    }
  }
}
