import 'package:flutter/material.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';

/// Widget pour la saisie de message avec bouton d'envoi
class MessageInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isLoading;
  
  const MessageInput({
    Key? key,
    required this.onSendMessage,
    this.isLoading = false,
  }) : super(key: key);
  
  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _textController = TextEditingController();
  bool _hasText = false;
  
  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }
  
  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }
  
  void _onTextChanged() {
    setState(() {
      _hasText = _textController.text.isNotEmpty;
    });
  }
  
  void _handleSendMessage() {
    if (_textController.text.trim().isEmpty) return;
    
    widget.onSendMessage(_textController.text.trim());
    _textController.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Bouton de fonctionnalités supplémentaires (optionnel)
            _buildActionsButton(context),
            
            // Champ de texte
            Expanded(
              child: TextField(
                controller: _textController,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Posez votre question...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  suffixIcon: _hasText
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _textController.clear();
                          },
                        )
                      : null,
                ),
                onSubmitted: (_) => _handleSendMessage(),
                enabled: !widget.isLoading,
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Bouton d'envoi
            _buildSendButton(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSendButton(BuildContext context) {
    return Material(
      color: _hasText ? AppTheme.primaryColor : Colors.grey[300],
      shape: const CircleBorder(),
      child: InkWell(
        onTap: widget.isLoading || !_hasText ? null : _handleSendMessage,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(
                    Icons.send_rounded,
                    color: _hasText ? Colors.white : Colors.grey[400],
                  ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionsButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.add_circle_outline),
      onSelected: (value) {
        // Traiter les différentes actions
        switch (value) {
          case 'suggestion':
            // Demander des suggestions
            widget.onSendMessage('Pouvez-vous me donner des suggestions pour améliorer ma productivité ?');
            break;
          case 'analyse':
            // Demander une analyse
            widget.onSendMessage('J\'aimerais une analyse de ma productivité récente.');
            break;
          case 'document':
            // Demander de générer un document
            widget.onSendMessage('Pouvez-vous m\'aider à créer une facture ?');
            break;
          case 'task':
            // Demander de créer une tâche
            widget.onSendMessage('Créez un rappel pour ma réunion client de demain à 15h.');
            break;
          case 'financial':
            // Demander une analyse financière
            widget.onSendMessage('Analysez mes revenus du mois dernier.');
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'suggestion',
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 20),
              SizedBox(width: 10),
              Text('Demander suggestions'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'analyse',
          child: Row(
            children: [
              Icon(Icons.analytics_outlined, size: 20),
              SizedBox(width: 10),
              Text('Demander analyse'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'document',
          child: Row(
            children: [
              Icon(Icons.description_outlined, size: 20),
              SizedBox(width: 10),
              Text('Générer un document'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'task',
          child: Row(
            children: [
              Icon(Icons.task_alt, size: 20),
              SizedBox(width: 10),
              Text('Créer une tâche'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'financial',
          child: Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined, size: 20),
              SizedBox(width: 10),
              Text('Analyse financière'),
            ],
          ),
        ),
      ],
    );
  }
}