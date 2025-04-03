import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/chatbot_bloc.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isRecording = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatbotBloc>().add(SendMessage(message));
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _toggleVoiceRecording() {
    // In a real app, this would start/stop voice recording
    // and use speech-to-text to convert to text
    setState(() {
      _isRecording = !_isRecording;
    });
    
    if (!_isRecording) {
      // Simulating that recording is done and text is processed
      _messageController.text = 'What are some time management tips?';
    }
  }

  void _clearChat() {
    context.read<ChatbotBloc>().add(ClearChat());
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Business Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearChat,
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: BlocConsumer<ChatbotBloc, ChatbotState>(
        listener: (context, state) {
          if (state is ChatbotReady && state.messages.isNotEmpty) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          if (state is ChatbotInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatbotError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 48,
                  ),
                  SizedBox(height: AppTheme.spacing(2)),
                  Text(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppTheme.spacing(3)),
                  AppButton(
                    text: 'Try Again',
                    onPressed: () => context.read<ChatbotBloc>().add(
                      const SendMessage('Hello'),
                    ),
                    fullWidth: false,
                  ),
                ],
              ),
            );
          } else if (state is ChatbotReady) {
            return Column(
              children: [
                // Chat messages
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(AppTheme.spacing(2)),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
                ),
                
                // Typing indicator
                if (state.isProcessing)
                  Padding(
                    padding: EdgeInsets.all(AppTheme.spacing(2)),
                    child: const Row(
                      children: [
                        _TypingIndicator(),
                      ],
                    ),
                  ),
                
                // Message input
                _buildMessageInput(),
              ],
            );
          }
          
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUserMessage = message.sender == MessageSender.user;
    
    return Padding(
      padding: EdgeInsets.only(
        top: AppTheme.spacing(1),
        bottom: AppTheme.spacing(1),
        left: isUserMessage ? AppTheme.spacing(6) : 0,
        right: isUserMessage ? 0 : AppTheme.spacing(6),
      ),
      child: Row(
        mainAxisAlignment: isUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUserMessage) ...[
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.assistant, color: Colors.white),
              radius: 16,
            ),
            SizedBox(width: AppTheme.spacing(1)),
          ],
          
          Flexible(
            child: Container(
              padding: EdgeInsets.all(AppTheme.spacing(2)),
              decoration: BoxDecoration(
                color: isUserMessage 
                    ? AppColors.primary
                    : Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isUserMessage
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing(1)),
                  Text(
                    AppDateUtils.formatTime(message.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isUserMessage
                          ? Colors.white.withOpacity(0.7)
                          : Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (isUserMessage) ...[
            SizedBox(width: AppTheme.spacing(1)),
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person, color: Colors.grey),
              radius: 16,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacing(2)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Voice input button
            IconButton(
              onPressed: _toggleVoiceRecording,
              icon: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: _isRecording ? AppColors.error : null,
              ),
              tooltip: _isRecording ? 'Stop recording' : 'Voice input',
            ),
            
            // Text input field
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade100
                      : Colors.grey.shade800,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing(2),
                    vertical: AppTheme.spacing(1),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            
            SizedBox(width: AppTheme.spacing(1)),
            
            // Send button
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send, color: Colors.white),
                tooltip: 'Send message',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator({Key? key}) : super(key: key);

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.assistant, color: Colors.white),
          radius: 12,
        ),
        SizedBox(width: AppTheme.spacing(1)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacing(2),
            vertical: AppTheme.spacing(1),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Row(
                children: List.generate(3, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(
                        0.5 + 0.5 * ((_controller.value - 0.3 * index) % 1.0),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}
