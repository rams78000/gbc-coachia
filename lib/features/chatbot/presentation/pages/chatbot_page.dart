import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Ajouter un message de bienvenue initial
    _messages.add(
      ChatMessage(
        text: 'Bonjour ! Je suis votre assistant IA GBC CoachIA. Comment puis-je vous aider aujourd\'hui ?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    setState(() {
      _messages.add(
        ChatMessage(
          text: message,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
      _messageController.clear();
    });

    // Faire défiler automatiquement vers le bas
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });

    // Simuler une réponse de l'IA (dans une application réelle, cela viendrait d'une API)
    Future.delayed(const Duration(seconds: 1), () {
      _simulateAIResponse(message);
    });
  }

  void _simulateAIResponse(String userMessage) {
    String response = '';
    
    // Simuler différentes réponses basées sur le message de l'utilisateur
    if (userMessage.toLowerCase().contains('bonjour') || 
        userMessage.toLowerCase().contains('salut') || 
        userMessage.toLowerCase().contains('hello')) {
      response = 'Bonjour ! Comment puis-je vous aider avec votre entreprise aujourd\'hui ?';
    } else if (userMessage.toLowerCase().contains('facture') || 
               userMessage.toLowerCase().contains('facturation')) {
      response = 'Pour créer une nouvelle facture, allez dans la section Finance et cliquez sur "Nouvelle facture". Vous pouvez y ajouter vos services, définir les conditions de paiement et l\'envoyer directement à votre client.';
    } else if (userMessage.toLowerCase().contains('client') || 
               userMessage.toLowerCase().contains('prospect')) {
      response = 'La gestion de la relation client est essentielle. Je vous suggère de maintenir un contact régulier avec vos clients et de noter leurs préférences dans la section Clients.';
    } else if (userMessage.toLowerCase().contains('conseil') || 
               userMessage.toLowerCase().contains('astuce')) {
      response = 'Voici un conseil pour les entrepreneurs : bloquez du temps dans votre calendrier pour les tâches importantes mais non urgentes comme la planification stratégique et le développement personnel.';
    } else if (userMessage.toLowerCase().contains('merci')) {
      response = 'Je vous en prie ! N\'hésitez pas si vous avez d\'autres questions.';
    } else {
      response = 'Je comprends. Pour vous aider plus efficacement, pourriez-vous me donner plus de détails sur votre question concernant votre activité professionnelle ?';
    }
    
    setState(() {
      _isTyping = false;
      _messages.add(
        ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
    
    // Faire défiler automatiquement vers le bas après la réponse
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
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
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final goldColor = const Color(0xFFFFD700);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant IA'),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Afficher les options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message, primaryColor, goldColor);
                },
              ),
            ),
          ),
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDot(delay: 100),
                        _buildDot(delay: 300),
                        _buildDot(delay: 500),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          _buildMessageInputField(primaryColor),
        ],
      ),
    );
  }

  Widget _buildDot({required int delay}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        height: 8,
        width: 8,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, Color primaryColor, Color goldColor) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatarIcon(primaryColor),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                  bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildUserAvatar(goldColor),
        ],
      ),
    );
  }

  Widget _buildAvatarIcon(Color primaryColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.smart_toy,
        color: primaryColor,
        size: 24,
      ),
    );
  }

  Widget _buildUserAvatar(Color goldColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: goldColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.person,
        color: Color(0xFFB87333), // Copper/bronze
        size: 24,
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildMessageInputField(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: Colors.grey[600],
            ),
            onPressed: () {
              // Fonctionnalité pour joindre des fichiers
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Tapez votre message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              minLines: 1,
              maxLines: 5,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
