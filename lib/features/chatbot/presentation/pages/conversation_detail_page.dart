import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/empty_state.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../bloc/chatbot_bloc.dart';
import '../widgets/api_key_dialog.dart';
import '../widgets/input_message_box.dart';
import '../widgets/message_item.dart';
import '../widgets/suggested_prompts.dart';

class ConversationDetailPage extends StatefulWidget {
  final String conversationId;

  const ConversationDetailPage({
    Key? key,
    required this.conversationId,
  }) : super(key: key);

  @override
  _ConversationDetailPageState createState() => _ConversationDetailPageState();
}

class _ConversationDetailPageState extends State<ConversationDetailPage> {
  final ScrollController _scrollController = ScrollController();
  String? _pendingPrompt;

  @override
  void initState() {
    super.initState();
    context.read<ChatbotBloc>().add(
          LoadConversationDetail(conversationId: widget.conversationId),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
    return BlocConsumer<ChatbotBloc, ChatbotState>(
      listener: (context, state) {
        if (state is ConversationDetailLoaded) {
          // Faire défiler vers le bas lorsque les messages sont chargés
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
          
          // Si nous avons un message en attente (d'une suggestion), l'envoyer maintenant
          if (_pendingPrompt != null) {
            context.read<ChatbotBloc>().add(
                  SendMessage(
                    conversationId: widget.conversationId,
                    content: _pendingPrompt!,
                  ),
                );
            _pendingPrompt = null;
          }
        } else if (state is ApiKeyInvalid) {
          _showApiKeyDialog(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: _buildTitle(state),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showApiKeyDialog(context),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: _buildMessageList(context, state),
              ),
              _buildInputArea(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(ChatbotState state) {
    if (state is ConversationDetailLoaded) {
      return Text(state.conversation.title);
    } else if (state is ConversationMessageSending) {
      return Text(state.conversation.title);
    }
    return const Text('Conversation');
  }

  Widget _buildMessageList(BuildContext context, ChatbotState state) {
    if (state is ConversationDetailLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ConversationDetailLoaded) {
      final messages = state.conversation.messages;
      if (messages.isEmpty) {
        return _buildStartConversation(context);
      }
      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 16.0),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return MessageItem(message: message);
        },
      );
    } else if (state is ConversationMessageSending) {
      final messages = [
        ...state.conversation.messages,
        Message(
          id: 'loading',
          content: 'Chargement...',
          role: MessageRole.assistant,
          timestamp: DateTime.now(),
          isLoading: true,
        ),
      ];
      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 16.0),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return MessageItem(message: message);
        },
      );
    } else {
      return const Center(child: Text('Erreur de chargement des messages'));
    }
  }

  Widget _buildStartConversation(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: EmptyState(
              icon: Icons.chat_bubble_outline,
              title: 'Commencez la conversation',
              description: 'Posez une question à GBC CoachIA pour obtenir de l\'aide avec votre entreprise.',
              showAction: false,
            ),
          ),
        ),
        SuggestedPromptsWidget(
          onPromptSelected: (prompt) => _sendMessage(context, prompt),
        ),
      ],
    );
  }

  Widget _buildInputArea(BuildContext context, ChatbotState state) {
    final isLoading = state is ConversationMessageSending;
    
    return InputMessageBox(
      onSendMessage: (content) => _sendMessage(context, content),
      isLoading: isLoading,
    );
  }

  void _sendMessage(BuildContext context, String content) {
    final currentState = context.read<ChatbotBloc>().state;
    
    if (currentState is ConversationDetailLoaded) {
      context.read<ChatbotBloc>().add(
            SendMessage(
              conversationId: widget.conversationId,
              content: content,
            ),
          );
    } else {
      // Si les messages ne sont pas encore chargés, stocker le message pour l'envoyer plus tard
      setState(() {
        _pendingPrompt = content;
      });
    }
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
}
