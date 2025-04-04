import 'package:flutter/material.dart';

class ApiKeyDialog extends StatefulWidget {
  final Function(String) onApiKeySubmitted;
  final bool isKeyValid;
  final String? currentKey;

  const ApiKeyDialog({
    Key? key,
    required this.onApiKeySubmitted,
    this.isKeyValid = false,
    this.currentKey,
  }) : super(key: key);

  @override
  _ApiKeyDialogState createState() => _ApiKeyDialogState();
}

class _ApiKeyDialogState extends State<ApiKeyDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _obscureText = true;
  String? _errorMessage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentKey != null && widget.currentKey!.isNotEmpty) {
      _controller.text = widget.currentKey!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _submitApiKey() async {
    final apiKey = _controller.text.trim();
    
    if (apiKey.isEmpty) {
      setState(() {
        _errorMessage = 'La clé API ne peut pas être vide';
      });
      return;
    }
    
    if (!apiKey.startsWith('sk-')) {
      setState(() {
        _errorMessage = 'La clé API doit commencer par "sk-"';
      });
      return;
    }
    
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    
    try {
      widget.onApiKeySubmitted(apiKey);
      // La navigation sera gérée par le parent
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur: ${e.toString()}';
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.key,
              color: Color(0xFFB87333),
              size: 32,
            ),
            const SizedBox(height: 16),
            Text(
              widget.isKeyValid 
                  ? 'Modifier votre clé API OpenAI' 
                  : 'Configurer votre clé API OpenAI',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  const TextSpan(
                    text: 'Pour utiliser le chatbot GBC CoachIA, vous devez fournir une clé API OpenAI. Obtenez votre clé sur ',
                  ),
                  TextSpan(
                    text: 'platform.openai.com',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Clé API OpenAI',
                hintText: 'sk-...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.vpn_key),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _toggleObscureText,
                ),
                errorText: _errorMessage,
              ),
              obscureText: _obscureText,
              autocorrect: false,
              enableSuggestions: false,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(
                  Icons.security,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Votre clé API est stockée en toute sécurité sur votre appareil uniquement.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitApiKey,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB87333),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Enregistrer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
