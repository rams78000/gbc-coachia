import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:gbc_coachia/config/theme/app_theme.dart';

class VoiceMessageRecorder extends StatefulWidget {
  final Function(String) onSpeechResult;
  final Function() onCancel;

  const VoiceMessageRecorder({
    Key? key,
    required this.onSpeechResult,
    required this.onCancel,
  }) : super(key: key);

  @override
  _VoiceMessageRecorderState createState() => _VoiceMessageRecorderState();
}

class _VoiceMessageRecorderState extends State<VoiceMessageRecorder> {
  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';
  bool _isListening = false;
  List<double> _soundLevels = List.filled(25, 0);
  double _currentLevel = 0;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize(
      onStatus: (status) {
        if (status == SpeechToText.doneStatus) {
          setState(() {
            _isListening = false;
          });
          if (_lastWords.isNotEmpty) {
            widget.onSpeechResult(_lastWords);
          } else {
            widget.onCancel();
          }
        }
      },
    );
    
    _startListening();
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _lastWords = result.recognizedWords;
          _currentLevel = result.hasConfidenceRating 
              ? result.confidence 
              : _calculateLevel(result.soundLevel);
          
          _updateSoundLevels(_currentLevel);
        });
      },
      localeId: 'fr_FR',
    );
    
    setState(() {
      _isListening = true;
    });
  }

  void _updateSoundLevels(double level) {
    setState(() {
      _soundLevels.removeAt(0);
      _soundLevels.add(level);
    });
  }

  double _calculateLevel(double soundLevel) {
    // Normaliser les niveaux sonores entre 0.0 et 1.0
    return soundLevel < 0 ? 0 : (soundLevel > 100 ? 1.0 : soundLevel / 100);
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
    });
    
    if (_lastWords.isNotEmpty) {
      widget.onSpeechResult(_lastWords);
    } else {
      widget.onCancel();
    }
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Enregistrement vocal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _speechToText.cancel();
                  widget.onCancel();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _buildMicButton(),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildWaveform(),
                ),
                const SizedBox(width: 8),
                Text(
                  _lastWords.isEmpty 
                      ? 'Parlez maintenant...' 
                      : 'Continuer ou valider',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: _lastWords.isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_lastWords.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Texte reconnu :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(_lastWords),
                ],
              ),
            ),
          const SizedBox(height: 12),
          if (_lastWords.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _lastWords = '';
                    });
                    _startListening();
                  },
                  child: const Text('Recommencer'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => widget.onSpeechResult(_lastWords),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Valider'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: _isListening ? _stopListening : _startListening,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _isListening ? AppTheme.primaryColor : Colors.grey[400],
          shape: BoxShape.circle,
        ),
        child: Icon(
          _isListening ? Icons.mic : Icons.mic_off,
          color: Colors.white,
        ),
      )
      .animate(target: _isListening ? 1 : 0)
      .scale(
        begin: 1.0,
        end: 1.1,
        duration: 500.ms,
        curve: Curves.easeInOut,
      )
      .then()
      .scale(
        begin: 1.1,
        end: 1.0,
        duration: 500.ms,
        curve: Curves.easeInOut,
      )
      .repeat(),
    );
  }

  Widget _buildWaveform() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        15,
        (index) {
          final level = _soundLevels[index + 5];
          return Container(
            width: 4,
            height: 30 * level + 3,
            decoration: BoxDecoration(
              color: _isListening 
                  ? AppTheme.primaryColor.withOpacity(0.5 + (level * 0.5))
                  : Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ).animate(target: _isListening ? 1 : 0).custom(
            duration: 100.ms,
            builder: (context, value, child) => Transform.scale(
              scaleY: 0.3 + (value * 0.7),
              child: child,
            ),
          );
        },
      ),
    );
  }
}