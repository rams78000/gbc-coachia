import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/message.dart';
import '../bloc/chatbot_bloc.dart';
import '../widgets/message_item.dart';

class ConversationDetailPage extends StatefulWidget {
  final String conversationId;

  const ConversationDetailPage({
    Key? key,
    required this.conversationId,
  }) : super(key: key);

  @override
  State<ConversationDetailPage> createState() => _ConversationDetailPageState();
}

class _ConversationDetailPageState extends State<ConversationDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Charger la conversation au démarrage
    context.read<ChatbotBloc>().add(ChatbotLoadConversation(widget.conversationId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Faire défiler jusqu'au dernier message
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ChatbotBloc, ChatbotState>(
          builder: (context, state) {
            if (state is ChatbotConversationLoaded) {
              return Text(state.conversation.title);
            }
            return const Text('Conversation');
          },
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: BlocConsumer<ChatbotBloc, ChatbotState>(
              listener: (context, state) {
                if (state is ChatbotConversationLoaded) {
                  // Après avoir chargé la conversation ou envoyé un message, faire défiler vers le bas
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                }
              },
              builder: (context, state) {
                if (state is ChatbotLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatbotConversationLoaded) {
                  final messages = state.conversation.messages;
                  
                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Démarrez la conversation',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'Posez une question ou demandez de l\'aide à propos de votre entreprise',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return MessageItem(message: message);
                    },
                  );
                } else if (state is ChatbotError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Erreur: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('Chargement de la conversation...'));
                }
              },
            ),
          ),
          
          // Indicateur de chargement
          BlocBuilder<ChatbotBloc, ChatbotState>(
            builder: (context, state) {
              if (state is ChatbotConversationLoaded && state.isProcessing) {
                return const LinearProgressIndicator();
              }
              return const SizedBox.shrink();
            },
          ),
          
          // Zone de saisie
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -1),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Tapez un message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        _sendMessage();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ClipOval(
                  child: Material(
                    color: Color(0xFFB87333), // Couleur cuivre/bronze
                    child: InkWell(
                      onTap: _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    
    // Vérifier si nous ne sommes pas déjà en train de traiter un message
    final state = context.read<ChatbotBloc>().state;
    if (state is ChatbotConversationLoaded && state.isProcessing) return;
    
    // Envoyer le message
    context.read<ChatbotBloc>().add(ChatbotSendMessage(message));
    
    // Effacer le champ de texte
    _messageController.clear();
  }
}
