import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_icons.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../domain/entities/conversation.dart';
import '../bloc/chatbot_bloc.dart';
import '../widgets/api_key_dialog.dart';
import '../widgets/conversation_list_item.dart';
import '../widgets/suggested_prompts.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatbotBloc>().add(const LoadConversations());
    context.read<ChatbotBloc>().add(const CheckApiKey());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatbotBloc, ChatbotState>(
      listener: (context, state) {
        if (state is ApiKeyInvalid) {
          _showApiKeyDialog(context);
        } else if (state is ConversationCreated) {
          context.push('/chatbot/conversation/${state.conversation.id}');
        } else if (state is ChatbotError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('GBC CoachIA'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showApiKeyDialog(context),
              ),
            ],
          ),
          body: _buildBody(context, state),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _createNewConversation(context),
            backgroundColor: const Color(0xFFB87333),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ChatbotState state) {
    if (state is ConversationsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ConversationsLoaded) {
      return Column(
        children: [
          SuggestedPromptsWidget(
            onPromptSelected: (prompt) => _startNewConversationWithPrompt(context, prompt),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Divider(),
          ),
          Expanded(
            child: state.conversations.isEmpty
                ? EmptyState(
                    icon: AppIcons.chat,
                    title: 'Aucune conversation',
                    description: 'Commencez une nouvelle conversation avec GBC CoachIA pour obtenir de l\'aide avec votre entreprise.',
                    actionText: 'Nouvelle conversation',
                    onActionPressed: () => _createNewConversation(context),
                  )
                : _buildConversationsList(context, state.conversations),
          ),
        ],
      );
    } else {
      return const Center(child: Text('Erreur de chargement des conversations'));
    }
  }

  Widget _buildConversationsList(BuildContext context, List<Conversation> conversations) {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return ConversationListItem(
          conversation: conversation,
          onTap: () => context.push('/chatbot/conversation/${conversation.id}'),
          onDelete: () => _deleteConversation(context, conversation.id),
        );
      },
    );
  }

  void _showApiKeyDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BlocBuilder<ChatbotBloc, ChatbotState>(
        builder: (context, state) {
          return ApiKeyDialog(
            isKeyValid: state is ApiKeyValid,
            onApiKeySubmitted: (apiKey) {
              context.read<ChatbotBloc>().add(SetApiKey(apiKey: apiKey));
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }

  void _createNewConversation(BuildContext context) {
    final bloc = context.read<ChatbotBloc>();
    bloc.add(const CreateConversation(title: 'Nouvelle conversation'));
  }

  void _startNewConversationWithPrompt(BuildContext context, String prompt) {
    final bloc = context.read<ChatbotBloc>();
    bloc.add(const CreateConversation(title: 'Nouvelle conversation'));
    
    // L'écoute de l'état (listener) va gérer la navigation vers la nouvelle conversation.
    // Une fois là-bas, nous devrons envoyer le message de démarrage
  }

  void _deleteConversation(BuildContext context, String conversationId) {
    context.read<ChatbotBloc>().add(DeleteConversation(conversationId: conversationId));
  }
}
