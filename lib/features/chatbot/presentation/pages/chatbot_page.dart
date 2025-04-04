import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../config/di/service_locator.dart';
import '../../domain/entities/conversation.dart';
import '../bloc/chatbot_bloc.dart';
import '../widgets/conversation_list_item.dart';
import 'conversation_detail_page.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  @override
  void initState() {
    super.initState();
    // Charger les conversations au démarrage
    context.read<ChatbotBloc>().add(const ChatbotLoadConversations());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant IA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Actualiser la liste des conversations
              context.read<ChatbotBloc>().add(const ChatbotLoadConversations());
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatbotBloc, ChatbotState>(
        builder: (context, state) {
          if (state is ChatbotLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatbotConversationsLoaded) {
            return _buildConversationsList(context, state.conversations);
          } else if (state is ChatbotError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur: ${state.message}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatbotBloc>().add(const ChatbotLoadConversations());
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Démarrez une nouvelle conversation'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewConversationDialog(context),
        backgroundColor: Color(0xFFB87333),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildConversationsList(BuildContext context, List<Conversation> conversations) {
    if (conversations.isEmpty) {
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
            Text(
              'Aucune conversation',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Commencez une nouvelle conversation avec l\'IA',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showNewConversationDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle conversation'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: conversations.length,
      padding: const EdgeInsets.only(bottom: 80),
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return ConversationListItem(
          conversation: conversation,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConversationDetailPage(
                  conversationId: conversation.id,
                ),
              ),
            );
          },
          onDelete: () {
            context.read<ChatbotBloc>().add(ChatbotDeleteConversation(conversation.id));
          },
        );
      },
    );
  }

  void _showNewConversationDialog(BuildContext context) {
    final TextEditingController _titleController = TextEditingController(
      text: 'Nouvelle conversation',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle conversation'),
        content: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Titre de la conversation',
            hintText: 'Ex: Questions sur la gestion de trésorerie',
          ),
          autofocus: true,
          maxLength: 50,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = _titleController.text.trim();
              if (title.isNotEmpty) {
                context.read<ChatbotBloc>().add(ChatbotCreateConversation(title));
                
                // Attendre que la conversation soit créée
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.of(context).pop();
                  
                  // Si la création de conversation a réussi
                  final state = context.read<ChatbotBloc>().state;
                  if (state is ChatbotConversationLoaded) {
                    // Naviguer vers la page de détail de la conversation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationDetailPage(
                          conversationId: state.conversation.id,
                        ),
                      ),
                    );
                  }
                });
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}
