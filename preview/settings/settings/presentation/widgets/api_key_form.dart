import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/settings/domain/entities/app_settings.dart';
import 'package:gbc_coachia/features/settings/presentation/bloc/settings_bloc.dart';

/// Widget pour gérer les clés d'API
class ApiKeyForm extends StatefulWidget {
  final AIModel model;
  final String? initialValue;
  final String? initialEndpoint;
  
  const ApiKeyForm({
    Key? key,
    required this.model,
    this.initialValue,
    this.initialEndpoint,
  }) : super(key: key);
  
  @override
  State<ApiKeyForm> createState() => _ApiKeyFormState();
}

class _ApiKeyFormState extends State<ApiKeyForm> {
  late TextEditingController _apiKeyController;
  late TextEditingController _endpointController;
  bool _obscureText = true;
  bool _isValidating = false;
  bool? _isValid;
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController(text: widget.initialValue);
    _endpointController = TextEditingController(text: widget.initialEndpoint);
  }
  
  @override
  void dispose() {
    _apiKeyController.dispose();
    _endpointController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is ApiKeyValidated && state.model == widget.model) {
          setState(() {
            _isValidating = false;
            _isValid = state.isValid;
          });
          
          if (state.isValid) {
            // Sauvegarder la clé API si elle est valide
            context.read<SettingsBloc>().add(SaveApiKey(
              model: widget.model,
              apiKey: _apiKeyController.text,
            ));
            
            // Sauvegarder l'endpoint si c'est un modèle personnalisé
            if (widget.model == AIModel.custom) {
              context.read<SettingsBloc>().add(
                SaveCustomAIEndpoint(_endpointController.text),
              );
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Clé API sauvegardée avec succès !'),
                backgroundColor: Colors.green,
              ),
            );
            
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Clé API invalide. Veuillez vérifier et réessayer.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else if (state is SettingsError) {
          setState(() {
            _isValidating = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configurer la clé API ${widget.model.displayName}',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            
            TextFormField(
              controller: _apiKeyController,
              decoration: InputDecoration(
                labelText: 'Clé API',
                hintText: 'Entrez votre clé API ${widget.model.displayName}',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
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
                  return 'Veuillez entrer une clé API';
                }
                return null;
              },
            ),
            
            if (widget.model == AIModel.custom) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _endpointController,
                decoration: const InputDecoration(
                  labelText: 'Endpoint API',
                  hintText: 'Entrez l\'URL de votre API personnalisée',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un endpoint API';
                  }
                  if (!Uri.tryParse(value)!.isAbsolute) {
                    return 'Veuillez entrer une URL valide';
                  }
                  return null;
                },
              ),
            ],
            
            const SizedBox(height: 24),
            
            if (_isValid != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isValid! ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isValid! ? Icons.check_circle : Icons.error,
                      color: _isValid! ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isValid!
                            ? 'Clé API valide'
                            : 'Clé API invalide. Veuillez vérifier et réessayer.',
                        style: TextStyle(
                          color: _isValid! ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isValidating
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isValidating = true;
                              _isValid = null;
                            });
                            
                            context.read<SettingsBloc>().add(ValidateApiKey(
                              model: widget.model,
                              apiKey: _apiKeyController.text,
                              endpoint: widget.model == AIModel.custom
                                  ? _endpointController.text
                                  : null,
                            ));
                          }
                        },
                  child: _isValidating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Valider'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
