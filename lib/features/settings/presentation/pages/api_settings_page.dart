import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/repositories/settings_repository.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/api_key_form.dart';

class ApiSettingsPage extends StatelessWidget {
  const ApiSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
        GetIt.instance<SettingsRepository>(),
      )..add(const LoadSettings()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configuration des API'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/settings'),
          ),
        ),
        body: const _ApiSettingsContent(),
      ),
    );
  }
}

class _ApiSettingsContent extends StatefulWidget {
  const _ApiSettingsContent();

  @override
  State<_ApiSettingsContent> createState() => _ApiSettingsContentState();
}

class _ApiSettingsContentState extends State<_ApiSettingsContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SettingsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Erreur: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<SettingsBloc>().add(const LoadSettings());
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        } else if (state is SettingsLoaded) {
          final appSettings = state.appSettings;
          
          return Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'OpenAI'),
                  Tab(text: 'Deepseek'),
                  Tab(text: 'Gemini'),
                  Tab(text: 'Personnalisé'),
                ],
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).textTheme.bodyLarge?.color,
                indicatorColor: Theme.of(context).colorScheme.primary,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // OpenAI
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: ApiKeyForm(
                        apiName: 'OpenAI',
                        currentApiKey: appSettings.openAiApiKey,
                        onSubmitKey: (apiKey) {
                          context.read<SettingsBloc>().add(
                            UpdateOpenAiApiKey(apiKey),
                          );
                        },
                      ),
                    ),
                    
                    // Deepseek
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: ApiKeyForm(
                        apiName: 'Deepseek',
                        currentApiKey: appSettings.deepseekApiKey,
                        onSubmitKey: (apiKey) {
                          context.read<SettingsBloc>().add(
                            UpdateDeepseekApiKey(apiKey),
                          );
                        },
                      ),
                    ),
                    
                    // Gemini
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: ApiKeyForm(
                        apiName: 'Gemini',
                        currentApiKey: appSettings.geminiApiKey,
                        onSubmitKey: (apiKey) {
                          context.read<SettingsBloc>().add(
                            UpdateGeminiApiKey(apiKey),
                          );
                        },
                      ),
                    ),
                    
                    // API personnalisée
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: ApiKeyForm(
                        apiName: 'Personnalisée',
                        currentApiKey: appSettings.customApiKey,
                        apiUrl: appSettings.customApiUrl,
                        showUrlField: true,
                        onSubmitUrlAndKey: (apiUrl, apiKey) {
                          context.read<SettingsBloc>().add(
                            UpdateCustomApiDetails(
                              apiUrl: apiUrl, 
                              apiKey: apiKey,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        
        // État initial ou autre
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
