import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/message.dart';
import '../bloc/chatbot_bloc.dart';
import '../widgets/conversation_list.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

/// Page principale de l'assistant conversationnel (chatbot)
class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    // Initialiser le chatbot au chargement de la page
    context.read<ChatbotBloc>().add(const InitializeChatbot());
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  // Pour faire défiler automatiquement vers le bas après l'ajout d'un message
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  
  // Créer une nouvelle conversation
  void _createNewConversation() {
    final uuid = const Uuid();
    // Générer un titre par défaut avec la date du jour
    final now = DateTime.now();
    final title = 'Conversation du ${now.day}/${now.month}/${now.year}';
    
    context.read<ChatbotBloc>().add(CreateConversation(title));
  }
  
  // Sélectionner une conversation existante
  void _selectConversation(String id) {
    context.read<ChatbotBloc>().add(SelectConversation(id));
  }
  
  // Envoyer un message
  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;
    
    context.read<ChatbotBloc>().add(SendMessage(
      content: content,
    ));
    
    // Faire défiler vers le bas après l'envoi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ChatbotBloc, ChatbotState>(
          builder: (context, state) {
            if (state is ConversationsLoaded) {
              return Text(state.currentConversation?.title ?? 'Assistant IA');
            }
            return const Text('Assistant IA');
          },
        ),
        actions: [
          // Bouton pour actualiser la conversation
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ChatbotBloc>().add(const InitializeChatbot());
            },
          ),
          
          // Plus d'options (partager, supprimer, etc.)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              // Actions à implémenter plus tard
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 10),
                    Text('Partager'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20),
                    SizedBox(width: 10),
                    Text('Supprimer'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      
      // Drawer contenant la liste des conversations
      drawer: BlocBuilder<ChatbotBloc, ChatbotState>(
        builder: (context, state) {
          if (state is ConversationsLoaded) {
            return ConversationList(
              conversations: state.conversations,
              currentConversationId: state.currentConversation?.id,
              onConversationSelected: _selectConversation,
              onNewConversation: _createNewConversation,
            );
          }
          return const SizedBox.shrink();
        },
      ),
      
      // Corps principal de la page
      body: BlocConsumer<ChatbotBloc, ChatbotState>(
        listener: (context, state) {
          // Faire défiler automatiquement vers le bas lorsque la conversation est chargée
          if (state is ConversationsLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
        },
        builder: (context, state) {
          if (state is ChatbotInitial || state is ChatbotLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ConversationsLoaded || state is SendingMessage) {
            // Déterminer la conversation à afficher
            final Conversation? conversation = state is ConversationsLoaded
                ? state.currentConversation
                : (state as SendingMessage).conversation;
            
            if (conversation == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Aucune conversation active',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _createNewConversation,
                      child: const Text('Nouvelle conversation'),
                    ),
                  ],
                ),
              );
            }
            
            final bool isLoading = state is SendingMessage;
            
            return Column(
              children: [
                // Liste des messages
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: conversation.messages.length,
                    itemBuilder: (context, index) {
                      final message = conversation.messages[index];
                      return MessageBubble(message: message);
                    },
                  ),
                ),
                
                // Indicateur de chargement
                if (isLoading) const MessageTypingIndicator(),
                
                // Champ de saisie
                MessageInput(
                  onSendMessage: _sendMessage,
                  isLoading: isLoading,
                ),
              ],
            );
          } else if (state is ChatbotError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur: ${state.message}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatbotBloc>().add(const InitializeChatbot());
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          
          // État par défaut
          return const Center(
            child: Text('Chargement de l\'assistant...'),
          );
        },
      ),
      
      // Bouton d'action flottant pour créer une nouvelle conversation
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewConversation,
        tooltip: 'Nouvelle conversation',
        child: const Icon(Icons.add),
      ),
    );
  }
}