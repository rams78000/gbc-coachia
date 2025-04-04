import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:speech_to_text/speech_to_text.dart';
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
  final SpeechToText _speechToText = SpeechToText();
  late AnimationController _animationController;
  bool _showSendButton = false;
  bool _isListening = false;
  bool _isSpeechAvailable = false;
  String _lastRecognizedWords = '';
  
  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initSpeech();
  }
  
  void _initSpeech() async {
    try {
      final isAvailable = await _speechToText.initialize(
        onStatus: (status) => _onSpeechStatus(status),
        onError: (errorNotification) => _onSpeechError(errorNotification),
      );
      
      setState(() {
        _isSpeechAvailable = isAvailable;
      });
    } catch (e) {
      setState(() {
        _isSpeechAvailable = false;
      });
      print('Erreur d\'initialisation de la reconnaissance vocale: $e');
    }
  }
  
  void _onSpeechStatus(String status) {
    if (status == 'notListening' && _isListening) {
      setState(() {
        _isListening = false;
      });
    }
  }
  
  void _onSpeechError(dynamic error) {
    setState(() {
      _isListening = false;
    });
    print('Erreur de reconnaissance vocale: $error');
  }
  
  void _startListening() async {
    if (!_isSpeechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La reconnaissance vocale n\'est pas disponible sur cet appareil.')),
      );
      return;
    }
    
    setState(() {
      _isListening = true;
      _lastRecognizedWords = '';
    });
    
    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _lastRecognizedWords = result.recognizedWords;
          _controller.text = _lastRecognizedWords;
          _onTextChanged();
        });
      },
      localeId: 'fr_FR',
    );
  }
  
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
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
      setState(() {
        _showSendButton = false;
      });
      _animationController.reverse();
    }
  }
  
  void _onMicPressed() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }
  
  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _animationController.dispose();
    _speechToText.cancel();
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
                        hintText: _isListening 
                            ? 'Parlez maintenant...' 
                            : 'Saisissez votre message...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: _isListening ? const Color(0xFFB87333) : Colors.grey[500],
                        ),
                      ),
                      maxLines: null, // Pour permettre les messages multi-lignes
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      enabled: !widget.isLoading && !_isListening,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _sendMessage();
                        }
                      },
                    ),
                  ),
                  if (_showSendButton)
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: widget.isLoading 
                            ? Colors.grey[400] 
                            : const Color(0xFFB87333),
                      ),
                      onPressed: widget.isLoading ? null : _sendMessage,
                    ).animate().fade(duration: 200.ms),
                  if (!_showSendButton || _isListening)
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening
                            ? const Color(0xFFB87333)
                            : (widget.isLoading ? Colors.grey[400] : Colors.grey[600]),
                      ),
                      onPressed: widget.isLoading ? null : _onMicPressed,
                    )
                    .animate(target: _isListening ? 1 : 0)
                    .scale(
                      begin: 1.0,
                      end: 1.2,
                      duration: 500.ms,
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .scale(
                      begin: 1.2,
                      end: 1.0,
                      duration: 500.ms,
                      curve: Curves.easeInOut,
                    )
                    .repeat(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
