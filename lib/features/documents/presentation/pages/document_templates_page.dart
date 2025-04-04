import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_template.dart';
import 'package:gbc_coachia/features/documents/presentation/bloc/document_bloc.dart';
import 'package:gbc_coachia/features/documents/presentation/widgets/document_filter.dart';
import 'package:gbc_coachia/features/documents/presentation/widgets/template_card.dart';

/// Page affichant la liste des modèles de documents
class DocumentTemplatesPage extends StatefulWidget {
  const DocumentTemplatesPage({Key? key}) : super(key: key);

  @override
  State<DocumentTemplatesPage> createState() => _DocumentTemplatesPageState();
}

class _DocumentTemplatesPageState extends State<DocumentTemplatesPage> {
  int? _selectedTypeIndex;
  
  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: BlocBuilder<DocumentBloc, DocumentState>(
            builder: (context, state) {
              if (state is TemplatesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TemplatesLoaded) {
                final templates = state.templates;
                
                if (templates.isEmpty) {
                  return const Center(
                    child: Text('Aucun modèle trouvé'),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<DocumentBloc>().add(LoadTemplates());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80.0), // Pour le FAB
                    itemCount: templates.length,
                    itemBuilder: (context, index) {
                      final template = templates[index];
                      return TemplateCard(
                        template: template,
                        onTap: () {
                          _createDocumentFromTemplate(context, template);
                        },
                        onEdit: () {
                          // Édition d'un modèle (non implémentée pour l'instant)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Édition du modèle "${template.name}" (à implémenter)'),
                            ),
                          );
                        },
                        onDelete: () {
                          _showDeleteConfirmationDialog(context, template);
                        },
                      );
                    },
                  ),
                );
              } else if (state is TemplatesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Erreur: ${state.message}'),
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
                child: Text('Chargement des modèles...'),
              );
            },
          ),
        ),
      ],
    );
  }
  
  // Applique les filtres sélectionnés
  void _applyFilters() {
    final bloc = context.read<DocumentBloc>();
    
    if (_selectedTypeIndex != null && _selectedTypeIndex! >= 0) {
      // Filtrer par type
      final type = DocumentType.values[_selectedTypeIndex!];
      bloc.add(FilterTemplatesByType(type));
    } else {
      // Pas de filtre, charger tous les modèles
      bloc.add(LoadTemplates());
    }
  }

  // Affiche une boîte de dialogue de confirmation pour la suppression
  void _showDeleteConfirmationDialog(BuildContext context, DocumentTemplate template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer le modèle "${template.name}" ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<DocumentBloc>().add(DeleteTemplate(template.id));
            },
            child: const Text('Supprimer'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // Crée un nouveau document à partir d'un modèle
  void _createDocumentFromTemplate(BuildContext context, DocumentTemplate template) {
    Navigator.pushNamed(
      context,
      '/documents/create',
      arguments: template.id,
    );
  }
}
