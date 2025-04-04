import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_template.dart';
import 'package:gbc_coachia/features/documents/presentation/bloc/document_bloc.dart';
import 'package:gbc_coachia/features/documents/presentation/widgets/document_filter.dart';
import 'package:gbc_coachia/features/documents/presentation/widgets/document_template_card.dart';

/// Page de sélection des modèles de documents
class TemplatesPage extends StatefulWidget {
  const TemplatesPage({Key? key}) : super(key: key);

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  int? _selectedTypeIndex;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    context.read<DocumentBloc>().add(LoadTemplates());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir un modèle'),
        elevation: 0,
        actions: [
          // Recherche
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filtre par type
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Filtrer par type',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                DocumentFilter(
                  isTypeFilter: true,
                  selectedIndex: _selectedTypeIndex,
                  onFilterSelected: (index) {
                    setState(() {
                      _selectedTypeIndex = index == _selectedTypeIndex ? null : index;
                    });
                    
                    _applyFilters();
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16.0),
          
          // Liste des modèles
          Expanded(
            child: BlocConsumer<DocumentBloc, DocumentState>(
              listener: (context, state) {
                if (state is DocumentGenerated) {
                  // Rediriger vers la page de détail du document généré
                  Navigator.pushReplacementNamed(
                    context,
                    '/documents/detail',
                    arguments: state.document.id,
                  );
                  
                  // Afficher un message de succès
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Document "${state.document.title}" créé avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is DocumentGenerationError) {
                  // Afficher un message d'erreur
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is TemplatesLoaded) {
                  final templates = state.templates;
                  
                  // Filtrer par recherche
                  List<DocumentTemplate> filteredTemplates = templates;
                  if (_searchQuery.isNotEmpty) {
                    filteredTemplates = templates.where((template) {
                      return template.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                             template.description.toLowerCase().contains(_searchQuery.toLowerCase());
                    }).toList();
                  }
                  
                  if (filteredTemplates.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 64.0,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Aucun modèle ne correspond à votre recherche'
                                : 'Aucun modèle disponible',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: filteredTemplates.length,
                    itemBuilder: (context, index) {
                      final template = filteredTemplates[index];
                      return DocumentTemplateCard(
                        template: template,
                        onTap: () {
                          // Naviguer vers la page de création avec ce modèle
                          Navigator.pushNamed(
                            context,
                            '/documents/create',
                            arguments: template.id,
                          );
                        },
                      );
                    },
                  );
                }
                
                if (state is TemplatesError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64.0,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Erreur: ${state.message}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            context.read<DocumentBloc>().add(LoadTemplates());
                          },
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }
                
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // Affiche la boîte de dialogue de recherche
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rechercher un modèle'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Entrez un mot-clé...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _searchQuery = '';
                });
              },
              child: const Text('Réinitialiser'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Rechercher'),
            ),
          ],
        );
      },
    );
  }
  
  // Applique les filtres sélectionnés
  void _applyFilters() {
    if (_selectedTypeIndex != null && _selectedTypeIndex! >= 0) {
      final type = DocumentType.values[_selectedTypeIndex!];
      context.read<DocumentBloc>().add(FilterTemplatesByType(type));
    } else {
      context.read<DocumentBloc>().add(LoadTemplates());
    }
  }
}
