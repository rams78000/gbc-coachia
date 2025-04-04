import 'package:flutter/material.dart';

class ApiKeyForm extends StatefulWidget {
  final String? currentApiKey;
  final String apiName;
  final String? apiUrl;
  final bool showUrlField;
  final Function(String) onSubmitKey;
  final Function(String, String)? onSubmitUrlAndKey;

  const ApiKeyForm({
    super.key,
    this.currentApiKey,
    required this.apiName,
    this.apiUrl,
    this.showUrlField = false,
    required this.onSubmitKey,
    this.onSubmitUrlAndKey,
  }) : assert(
          !showUrlField || onSubmitUrlAndKey != null,
          'Si showUrlField est true, onSubmitUrlAndKey ne peut être null',
        );

  @override
  State<ApiKeyForm> createState() => _ApiKeyFormState();
}

class _ApiKeyFormState extends State<ApiKeyForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _apiKeyController;
  late TextEditingController _apiUrlController;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController(text: widget.currentApiKey ?? '');
    _apiUrlController = TextEditingController(text: widget.apiUrl ?? '');
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _apiUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuration ${widget.apiName}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Entrez votre clé API pour utiliser les services ${widget.apiName} dans l\'application.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
          const SizedBox(height: 24),
          
          // URL de l'API (si nécessaire)
          if (widget.showUrlField) ...[
            TextFormField(
              controller: _apiUrlController,
              decoration: const InputDecoration(
                labelText: 'URL de l\'API',
                hintText: 'https://api.example.com/v1',
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer l\'URL de l\'API';
                }
                if (!value.startsWith('http://') && !value.startsWith('https://')) {
                  return 'L\'URL doit commencer par http:// ou https://';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],
          
          // Champ de clé API
          TextFormField(
            controller: _apiKeyController,
            decoration: InputDecoration(
              labelText: 'Clé API',
              hintText: 'Entrez votre clé API',
              prefixIcon: const Icon(Icons.vpn_key),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            obscureText: _obscureText,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre clé API';
              }
              if (value.length < 8) {
                return 'La clé API doit contenir au moins 8 caractères';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 8),
          Text(
            'Votre clé API est stockée uniquement sur votre appareil et n\'est jamais partagée.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
          
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (widget.showUrlField) {
                    widget.onSubmitUrlAndKey!(
                      _apiUrlController.text,
                      _apiKeyController.text,
                    );
                  } else {
                    widget.onSubmitKey(_apiKeyController.text);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Clé API enregistrée avec succès'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Enregistrer'),
            ),
          ),
          const SizedBox(height: 16),
          if (widget.currentApiKey != null) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  if (widget.showUrlField) {
                    widget.onSubmitUrlAndKey!('', '');
                  } else {
                    widget.onSubmitKey('');
                  }
                  _apiKeyController.clear();
                  if (widget.showUrlField) {
                    _apiUrlController.clear();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Clé API supprimée'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Supprimer la clé API'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
