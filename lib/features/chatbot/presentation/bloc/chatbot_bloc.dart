import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/message.dart';

// Events
abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object?> get props => [];
}

/// Événement déclenché pour initialiser le chatbot
class InitializeChatbot extends ChatbotEvent {
  const InitializeChatbot();
}

/// Événement déclenché quand l'utilisateur envoie un message
class SendMessage extends ChatbotEvent {
  final String content;
  final MessageType type;

  const SendMessage({
    required this.content,
    this.type = MessageType.text,
  });

  @override
  List<Object?> get props => [content, type];
}

/// Événement déclenché pour charger l'historique des conversations
class LoadConversations extends ChatbotEvent {
  const LoadConversations();
}

/// Événement déclenché pour sélectionner une conversation
class SelectConversation extends ChatbotEvent {
  final String conversationId;

  const SelectConversation(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

/// Événement déclenché pour créer une nouvelle conversation
class CreateConversation extends ChatbotEvent {
  final String title;

  const CreateConversation(this.title);

  @override
  List<Object?> get props => [title];
}

// States
abstract class ChatbotState extends Equatable {
  const ChatbotState();
  
  @override
  List<Object?> get props => [];
}

/// État initial du chatbot
class ChatbotInitial extends ChatbotState {
  const ChatbotInitial();
}

/// État de chargement du chatbot
class ChatbotLoading extends ChatbotState {
  const ChatbotLoading();
}

/// État quand les conversations sont chargées
class ConversationsLoaded extends ChatbotState {
  final List<Conversation> conversations;
  final Conversation? currentConversation;

  const ConversationsLoaded({
    required this.conversations,
    this.currentConversation,
  });

  @override
  List<Object?> get props => [conversations, currentConversation];

  /// Crée une copie de cet état avec les valeurs spécifiées
  ConversationsLoaded copyWith({
    List<Conversation>? conversations,
    Conversation? currentConversation,
  }) {
    return ConversationsLoaded(
      conversations: conversations ?? this.conversations,
      currentConversation: currentConversation ?? this.currentConversation,
    );
  }
}

/// État quand l'envoi d'un message est en cours
class SendingMessage extends ChatbotState {
  final Conversation conversation;

  const SendingMessage(this.conversation);

  @override
  List<Object?> get props => [conversation];
}

/// État d'erreur du chatbot
class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  // Dépendances (à injecter plus tard par un système DI)
  // final ChatRepository repository;
  // final OpenAIService openAIService;
  
  final _uuid = const Uuid();
  
  ChatbotBloc() : super(const ChatbotInitial()) {
    on<InitializeChatbot>(_onInitializeChatbot);
    on<SendMessage>(_onSendMessage);
    on<LoadConversations>(_onLoadConversations);
    on<SelectConversation>(_onSelectConversation);
    on<CreateConversation>(_onCreateConversation);
  }

  Future<void> _onInitializeChatbot(
    InitializeChatbot event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(const ChatbotLoading());
    try {
      // Dans une implémentation réelle, charger les conversations depuis un repository
      await _onLoadConversations(const LoadConversations(), emit);
    } catch (e) {
      emit(ChatbotError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatbotState> emit,
  ) async {
    // Vérifier qu'il y a une conversation active
    if (state is! ConversationsLoaded) {
      emit(const ChatbotError('Aucune conversation active'));
      return;
    }
    
    final currentState = state as ConversationsLoaded;
    final currentConversation = currentState.currentConversation;
    
    if (currentConversation == null) {
      emit(const ChatbotError('Aucune conversation active'));
      return;
    }
    
    try {
      // Créer le message utilisateur
      final userMessage = Message.user(
        id: _uuid.v4(),
        content: event.content,
        type: event.type,
      );
      
      // Mettre à jour la conversation avec le message utilisateur
      var updatedConversation = currentConversation.addMessage(userMessage);
      
      // Mettre à jour l'état pour montrer le message de l'utilisateur
      emit(SendingMessage(updatedConversation));
      
      // Simuler une réponse de l'IA (à remplacer par un appel API réel)
      await Future.delayed(const Duration(seconds: 1));
      
      // Créer le message assistant (IA)
      final assistantMessage = await _generateAIResponse(event.content, event.type);
      
      // Mettre à jour la conversation avec le message assistant
      updatedConversation = updatedConversation.addMessage(assistantMessage);
      
      // Mettre à jour la liste des conversations
      final updatedConversations = currentState.conversations.map((conversation) {
        if (conversation.id == updatedConversation.id) {
          return updatedConversation;
        }
        return conversation;
      }).toList();
      
      // Mettre à jour l'état avec la nouvelle conversation
      emit(currentState.copyWith(
        conversations: updatedConversations,
        currentConversation: updatedConversation,
      ));
    } catch (e) {
      emit(ChatbotError(e.toString()));
    }
  }

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(const ChatbotLoading());
    try {
      // Dans une implémentation réelle, charger les conversations depuis un repository
      // Simulation de données pour le moment
      final conversations = _generateSampleConversations();
      
      emit(ConversationsLoaded(
        conversations: conversations,
        currentConversation: conversations.isNotEmpty ? conversations.first : null,
      ));
    } catch (e) {
      emit(ChatbotError(e.toString()));
    }
  }

  Future<void> _onSelectConversation(
    SelectConversation event,
    Emitter<ChatbotState> emit,
  ) async {
    if (state is! ConversationsLoaded) {
      emit(const ChatbotError('Impossible de sélectionner une conversation'));
      return;
    }
    
    final currentState = state as ConversationsLoaded;
    try {
      final selectedConversation = currentState.conversations
          .firstWhere((conversation) => conversation.id == event.conversationId);
      
      emit(currentState.copyWith(
        currentConversation: selectedConversation,
      ));
    } catch (e) {
      emit(ChatbotError('Conversation introuvable: ${e.toString()}'));
    }
  }

  Future<void> _onCreateConversation(
    CreateConversation event,
    Emitter<ChatbotState> emit,
  ) async {
    if (state is! ConversationsLoaded) {
      await _onLoadConversations(const LoadConversations(), emit);
    }
    
    if (state is! ConversationsLoaded) {
      emit(const ChatbotError('Impossible de créer une conversation'));
      return;
    }
    
    final currentState = state as ConversationsLoaded;
    try {
      final newConversation = Conversation.create(
        id: _uuid.v4(),
        title: event.title,
      );
      
      // Ajouter un message système de bienvenue
      final updatedConversation = newConversation.addMessage(Message.system(
        id: _uuid.v4(),
        content: 'Bonjour, je suis votre coach IA. Comment puis-je vous aider aujourd\'hui ?',
      ));
      
      emit(currentState.copyWith(
        conversations: [updatedConversation, ...currentState.conversations],
        currentConversation: updatedConversation,
      ));
    } catch (e) {
      emit(ChatbotError(e.toString()));
    }
  }

  // Méthode pour générer une réponse IA simulée
  // À remplacer par un appel à l'API OpenAI dans une implémentation réelle
  Future<Message> _generateAIResponse(String userMessage, MessageType type) async {
    // Simulation de réponse pour le moment
    String response;
    MessageType responseType;
    
    switch (type) {
      case MessageType.text:
        if (userMessage.toLowerCase().contains('productivité')) {
          response = 'Pour améliorer votre productivité, je vous recommande d\'essayer la technique Pomodoro : 25 minutes de travail concentré suivies de 5 minutes de pause. Voulez-vous que je crée un planning basé sur cette technique ?';
          responseType = MessageType.suggestion;
        } else if (userMessage.toLowerCase().contains('finance') || 
                  userMessage.toLowerCase().contains('revenu') ||
                  userMessage.toLowerCase().contains('dépense')) {
          response = 'Je peux analyser vos revenus et dépenses pour vous aider à optimiser votre gestion financière. Souhaitez-vous une analyse détaillée ?';
          responseType = MessageType.financialAnalysis;
        } else if (userMessage.toLowerCase().contains('document') ||
                  userMessage.toLowerCase().contains('facture') ||
                  userMessage.toLowerCase().contains('contrat')) {
          response = 'Je peux vous aider à générer des documents professionnels. Quel type de document souhaitez-vous créer ?';
          responseType = MessageType.documentGeneration;
        } else if (userMessage.toLowerCase().contains('tâche') ||
                  userMessage.toLowerCase().contains('rappel') ||
                  userMessage.toLowerCase().contains('calendrier')) {
          response = 'Je peux créer une tâche ou un événement dans votre calendrier. Quand souhaitez-vous planifier cette activité ?';
          responseType = MessageType.taskCreation;
        } else {
          response = 'Je comprends votre demande. Comment puis-je vous assister davantage dans votre activité professionnelle ?';
          responseType = MessageType.text;
        }
        break;
      case MessageType.suggestion:
        response = 'Voici quelques suggestions pour améliorer votre activité : \n\n1. Définir des objectifs SMART\n2. Déléguer les tâches moins importantes\n3. Automatiser les processus répétitifs\n\nVoulez-vous plus de détails sur l\'une de ces suggestions ?';
        responseType = MessageType.suggestion;
        break;
      case MessageType.analysis:
        response = 'D\'après l\'analyse de vos données, votre productivité est meilleure entre 9h et 11h. Je vous recommande de planifier vos tâches les plus importantes pendant cette plage horaire.';
        responseType = MessageType.analysis;
        break;
      default:
        response = 'Je suis là pour vous aider dans la gestion de votre activité professionnelle. N\'hésitez pas à me poser des questions.';
        responseType = MessageType.text;
    }
    
    return Message.assistant(
      id: _uuid.v4(),
      content: response,
      type: responseType,
    );
  }

  // Méthode pour générer des conversations d'exemple
  List<Conversation> _generateSampleConversations() {
    // Conversation 1
    final conversation1 = Conversation.create(
      id: _uuid.v4(),
      title: 'Amélioration de la productivité',
    ).addMessage(Message.system(
      id: _uuid.v4(),
      content: 'Bonjour, je suis votre coach IA. Comment puis-je vous aider aujourd\'hui ?',
    )).addMessage(Message.user(
      id: _uuid.v4(),
      content: 'Comment puis-je améliorer ma productivité ?',
    )).addMessage(Message.assistant(
      id: _uuid.v4(),
      content: 'Pour améliorer votre productivité, je vous recommande d\'essayer la technique Pomodoro : 25 minutes de travail concentré suivies de 5 minutes de pause. Voulez-vous que je crée un planning basé sur cette technique ?',
      type: MessageType.suggestion,
    ));
    
    // Conversation 2
    final conversation2 = Conversation.create(
      id: _uuid.v4(),
      title: 'Analyse financière',
    ).addMessage(Message.system(
      id: _uuid.v4(),
      content: 'Bonjour, je suis votre coach IA. Comment puis-je vous aider aujourd\'hui ?',
    )).addMessage(Message.user(
      id: _uuid.v4(),
      content: 'Pouvez-vous analyser mes revenus du dernier trimestre ?',
    )).addMessage(Message.assistant(
      id: _uuid.v4(),
      content: 'D\'après l\'analyse de vos données financières, vos revenus ont augmenté de 15% par rapport au trimestre précédent. Votre plus grande source de revenus provient des prestations de conseil (65%). Souhaitez-vous une analyse plus détaillée ?',
      type: MessageType.financialAnalysis,
    ));
    
    return [conversation1, conversation2];
  }
}