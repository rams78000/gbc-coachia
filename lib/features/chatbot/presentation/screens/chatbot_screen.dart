import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Chat message model
class ChatMessage {
  /// Constructor
  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  /// Message text
  final String text;

  /// Whether message is from user
  final bool isUser;

  /// Message timestamp
  final DateTime timestamp;
}

/// Chatbot screen
class ChatbotScreen extends StatefulWidget {
  /// Constructor
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _addBotMessage(
      'Bonjour ! Je suis votre assistant IA personnel. Comment puis-je vous aider aujourd\'hui ?',
    );
    
    // Add suggestions
    Future.delayed(const Duration(milliseconds: 500), () {
      _addBotMessage(
        'Voici quelques façons dont je peux vous aider :\n'
        '• Conseils pour améliorer votre productivité\n'
        '• Stratégies de développement commercial\n'
        '• Astuces pour gérer votre trésorerie\n'
        '• Idées pour le marketing de votre entreprise',
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addUserMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

    // Simulate bot thinking
    setState(() {
      _isLoading = true;
    });

    // Simulate response delay
    Future.delayed(const Duration(seconds: 1), () {
      _handleBotResponse(text);
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
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

  void _handleBotResponse(String userMessage) {
    // Simple response logic for demo
    final lowerUserMessage = userMessage.toLowerCase();

    if (lowerUserMessage.contains('bonjour') ||
        lowerUserMessage.contains('salut') ||
        lowerUserMessage.contains('hello')) {
      _addBotMessage('Bonjour ! Comment puis-je vous aider aujourd\'hui ?');
    } else if (lowerUserMessage.contains('productivité') ||
               lowerUserMessage.contains('productif')) {
      _addBotMessage(
        'Pour améliorer votre productivité, essayez ces techniques :\n\n'
        '1. La technique Pomodoro : travaillez 25 minutes, puis prenez une pause de 5 minutes\n'
        '2. Planifiez vos journées la veille\n'
        '3. Réduisez les distractions en désactivant les notifications\n'
        '4. Identifiez votre moment de productivité optimal dans la journée\n'
        '5. Utilisez des outils de gestion de tâches comme notre fonction Planner',
      );
    } else if (lowerUserMessage.contains('marketing') ||
               lowerUserMessage.contains('client') ||
               lowerUserMessage.contains('vente')) {
      _addBotMessage(
        'Pour améliorer votre marketing et attirer plus de clients :\n\n'
        '1. Définissez clairement votre proposition de valeur unique\n'
        '2. Utilisez le marketing de contenu pour établir votre expertise\n'
        '3. Exploitez les médias sociaux de manière stratégique\n'
        '4. Demandez des témoignages à vos clients satisfaits\n'
        '5. Envisagez des partenariats stratégiques avec d\'autres entreprises',
      );
    } else if (lowerUserMessage.contains('finance') ||
               lowerUserMessage.contains('argent') ||
               lowerUserMessage.contains('trésorerie')) {
      _addBotMessage(
        'Pour mieux gérer vos finances d\'entreprise :\n\n'
        '1. Suivez vos revenus et dépenses régulièrement\n'
        '2. Créez un budget et respectez-le\n'
        '3. Gardez une réserve de trésorerie pour les urgences\n'
        '4. Facturez rapidement et suivez les paiements en retard\n'
        '5. Utilisez notre outil de gestion financière pour automatiser le suivi',
      );
    } else if (lowerUserMessage.contains('merci')) {
      _addBotMessage(
        'Je vous en prie ! N\'hésitez pas à me solliciter si vous avez d\'autres questions.',
      );
    } else {
      _addBotMessage(
        'Je ne suis pas sûr de comprendre votre demande. Pourriez-vous reformuler ou préciser votre question ? Vous pouvez me demander des conseils sur la productivité, le marketing, la gestion financière ou le développement de votre entreprise.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('Assistant IA'),
            Text(
              'Disponible 24/7',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('À propos de l\'Assistant IA'),
                  content: const Text(
                    'Votre assistant personnel IA est conçu pour vous aider avec des conseils d\'entreprise, des stratégies de productivité et des réponses à vos questions professionnelles.\n\n'
                    'Il apprend de vos interactions pour offrir des conseils de plus en plus pertinents.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Loading indicator
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(width: 16),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('L\'assistant réfléchit...'),
                ],
              ),
            ),

          // Quick suggestion chips
          if (!_isLoading && _messages.length <= 3)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildSuggestionChip('Comment améliorer ma productivité ?'),
                  _buildSuggestionChip('Conseils pour trouver des clients'),
                  _buildSuggestionChip('Astuces de gestion financière'),
                  _buildSuggestionChip('Stratégies de marketing digital'),
                ],
              ),
            ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -1),
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.05),
                ),
              ],
            ),
            child: Row(
              children: [
                // Text field
                Expanded(
                  child: AppTextField(
                    controller: _messageController,
                    hint: 'Tapez votre message...',
                    onSubmitted: (text) {
                      _addUserMessage(text);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Send button
                AppButton(
                  label: '',
                  icon: Icons.send,
                  variant: AppButtonVariant.primary,
                  size: AppButtonSize.small,
                  onPressed: () {
                    _addUserMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    final messageTime = DateFormat('HH:mm').format(message.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 16,
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: isUser ? AppColors.userMessageBubble : AppColors.botMessageBubble,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isUser ? Radius.circular(20) : Radius.circular(0),
                  bottomRight: !isUser ? Radius.circular(20) : Radius.circular(0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? AppColors.userMessageText : AppColors.botMessageText,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    messageTime,
                    style: TextStyle(
                      color: isUser
                          ? AppColors.userMessageText.withOpacity(0.7)
                          : AppColors.botMessageText.withOpacity(0.7),
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser)
            const CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 16,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text),
        onPressed: () {
          _addUserMessage(text);
        },
      ),
    );
  }
}
