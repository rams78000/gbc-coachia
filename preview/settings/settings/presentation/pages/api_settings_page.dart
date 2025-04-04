import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/settings/domain/entities/app_settings.dart';
import 'package:gbc_coachia/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:gbc_coachia/features/settings/presentation/widgets/api_key_form.dart';
import 'package:gbc_coachia/features/settings/presentation/widgets/settings_item.dart';
import 'package:gbc_coachia/features/settings/presentation/widgets/settings_section.dart';

/// Page de paramètres des API
class ApiSettingsPage extends StatefulWidget {
  const ApiSettingsPage({Key? key}) : super(key: key);
  
  @override
  State<ApiSettingsPage> createState() => _ApiSettingsPageState();
}

class _ApiSettingsPageState extends State<ApiSettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(LoadSettings());
  }
  
  void _openApiKeyDialog(AIModel model, String? currentKey, String? endpoint) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: ApiKeyForm(
              model: model,
              initialValue: currentKey,
              initialEndpoint: endpoint,
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration de l\'IA'),
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          AppSettings? settings;
          if (state is SettingsLoaded) {
            settings = state.settings;
          } else if (state is SettingsUpdated) {
            settings = state.settings;
          }
          
          if (settings == null) {
            return const Center(
              child: Text('Chargement des paramètres...'),
            );
          }
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Modèle d\'IA par défaut',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButtonFormField<AIModel>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Modèle par défaut',
                    ),
                    value: settings.aiModel,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        context.read<SettingsBloc>().add(UpdateDefaultAIModel(newValue));
                      }
                    },
                    items: AIModel.values.map((model) {
                      return DropdownMenuItem(
                        value: model,
                        child: Text(model.displayName),
                      );
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                SettingsSection(
                  title: 'Clés API',
                  children: [
                    SettingsItem(
                      title: 'OpenAI API',
                      subtitle: settings.apiKeys[AIModel.openai] != null
                          ? 'Clé API configurée'
                          : 'Clé API non configurée',
                      leading: const Icon(Icons.api),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _openApiKeyDialog(
                            AIModel.openai,
                            settings.apiKeys[AIModel.openai],
                            null,
                          );
                        },
                        child: Text(
                          settings.apiKeys[AIModel.openai] != null
                              ? 'Modifier'
                              : 'Configurer',
                        ),
                      ),
                    ),
                    
                    SettingsItem(
                      title: 'Deepseek API',
                      subtitle: settings.apiKeys[AIModel.deepseek] != null
                          ? 'Clé API configurée'
                          : 'Clé API non configurée',
                      leading: const Icon(Icons.api),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _openApiKeyDialog(
                            AIModel.deepseek,
                            settings.apiKeys[AIModel.deepseek],
                            null,
                          );
                        },
                        child: Text(
                          settings.apiKeys[AIModel.deepseek] != null
                              ? 'Modifier'
                              : 'Configurer',
                        ),
                      ),
                    ),
                    
                    SettingsItem(
                      title: 'Gemini 2.5 Pro API',
                      subtitle: settings.apiKeys[AIModel.gemini] != null
                          ? 'Clé API configurée'
                          : 'Clé API non configurée',
                      leading: const Icon(Icons.api),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _openApiKeyDialog(
                            AIModel.gemini,
                            settings.apiKeys[AIModel.gemini],
                            null,
                          );
                        },
                        child: Text(
                          settings.apiKeys[AIModel.gemini] != null
                              ? 'Modifier'
                              : 'Configurer',
                        ),
                      ),
                    ),
                    
                    SettingsItem(
                      title: 'API Personnalisée',
                      subtitle: settings.apiKeys[AIModel.custom] != null
                          ? 'API personnalisée configurée'
                          : 'API personnalisée non configurée',
                      leading: const Icon(Icons.settings),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _openApiKeyDialog(
                            AIModel.custom,
                            settings.apiKeys[AIModel.custom],
                            settings.customAIEndpoint,
                          );
                        },
                        child: Text(
                          settings.apiKeys[AIModel.custom] != null
                              ? 'Modifier'
                              : 'Configurer',
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'À propos des clés API',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Comment obtenir vos clés API',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pour utiliser les fonctionnalités d\'IA dans cette application, vous devez fournir vos propres clés API pour les services que vous souhaitez utiliser.',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          _buildApiKeyInstructionItem(
                            'OpenAI API',
                            'Rendez-vous sur https://platform.openai.com/api-keys pour créer une clé API.',
                            theme,
                          ),
                          const SizedBox(height: 8),
                          _buildApiKeyInstructionItem(
                            'Deepseek API',
                            'Créez un compte sur Deepseek et générez votre clé API.',
                            theme,
                          ),
                          const SizedBox(height: 8),
                          _buildApiKeyInstructionItem(
                            'Gemini API',
                            'Visitez https://ai.google.dev/ pour obtenir une clé API Gemini.',
                            theme,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Remarque : Vos clés API sont stockées en toute sécurité uniquement sur votre appareil et ne sont jamais partagées avec nos serveurs.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildApiKeyInstructionItem(
    String title,
    String description,
    ThemeData theme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
