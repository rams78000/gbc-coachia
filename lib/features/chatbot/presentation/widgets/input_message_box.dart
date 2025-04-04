import 'package:flutter/material.dart';
import 'dart:math' as math;

class InputMessageBox extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isLoading;
  
  const InputMessageBox({
    Key? key,
    required this.onSendMessage,
    this.isLoading = false,
  }) : super(key: key);

  @override
  _InputMessageBoxState createState() => _InputMessageBoxState();
}

class _InputMessageBoxState extends State<InputMessageBox> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  bool _showSendButton = false;
  
  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }
  
  void _onTextChanged() {
    final textIsNotEmpty = _controller.text.trim().isNotEmpty;
    if (textIsNotEmpty != _showSendButton) {
      setState(() {
        _showSendButton = textIsNotEmpty;
      });
      
      if (_showSendButton) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }
  
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isLoading) {
      widget.onSendMessage(text);
      _controller.clear();
    }
  }
  
  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: theme.inputDecorationTheme.fillColor ?? Colors.grey[200],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Saisissez votre message...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      maxLines: null, // Pour permettre les messages multi-lignes
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      enabled: !widget.isLoading,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _sendMessage();
                        }
                      },
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animationController.value * (math.pi / 2),
                        child: IconButton(
                          icon: Icon(
                            _showSendButton ? Icons.send : Icons.mic,
                            color: widget.isLoading 
                                ? Colors.grey[400] 
                                : const Color(0xFFB87333),
                          ),
                          onPressed: widget.isLoading ? null : _sendMessage,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
