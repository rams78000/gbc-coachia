import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/presentation/bloc/document_bloc.dart';
import 'package:gbc_coachia/features/documents/presentation/widgets/document_card.dart';
import 'package:gbc_coachia/features/documents/presentation/widgets/document_filter.dart';

/// Page affichant la liste des documents
class DocumentsListPage extends StatefulWidget {
  const DocumentsListPage({Key? key}) : super(key: key);

  @override
  State<DocumentsListPage> createState() => _DocumentsListPageState();
}

class _DocumentsListPageState extends State<DocumentsListPage> {
  int? _selectedTypeIndex;
  int? _selectedStatusIndex;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filtres
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filtre par type
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
              
              const SizedBox(height: 16.0),
              
              // Filtre par statut
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Filtrer par statut',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              DocumentFilter(
                isTypeFilter: false,
                selectedIndex: _selectedStatusIndex,
                onFilterSelected: (index) {
                  setState(() {
                    _selectedStatusIndex = index == _selectedStatusIndex ? null : index;
                  });
                  
                  _applyFilters();
                },
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16.0),
        
        // Liste des documents
        Expanded(
          child: BlocBuilder<DocumentBloc, DocumentState>(
            builder: (context, state) {
              if (state is DocumentsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is DocumentsLoaded) {
                final documents = state.documents;
                
                if (documents.isEmpty) {
                  return const Center(
                    child: Text('Aucun document trouvé'),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<DocumentBloc>().add(LoadDocuments());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80.0), // Pour le FAB
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];
                      return DocumentCard(
                        document: document,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/documents/detail',
                            arguments: document.id,
                          );
                        },
                        onEdit: () {
                          Navigator.pushNamed(
                            context,
                            '/documents/edit',
                            arguments: document.id,
                          );
                        },
                        onDelete: () {
                          _showDeleteConfirmationDialog(context, document);
                        },
                        onShare: () {
                          _shareDocument(context, document);
                        },
                      );
                    },
                  ),
                );
              } else if (state is DocumentsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Erreur: ${state.message}'),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          context.read<DocumentBloc>().add(LoadDocuments());
                        },
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                );
              }
              
              return const Center(
                child: Text('Chargement des documents...'),
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
      bloc.add(FilterDocumentsByType(type));
    } else if (_selectedStatusIndex != null && _selectedStatusIndex! >= 0) {
      // Filtrer par statut
      final status = DocumentStatus.values[_selectedStatusIndex!];
      bloc.add(FilterDocumentsByStatus(status));
    } else {
      // Pas de filtre, charger tous les documents
      bloc.add(LoadDocuments());
    }
  }

  // Affiche une boîte de dialogue de confirmation pour la suppression
  void _showDeleteConfirmationDialog(BuildContext context, Document document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer le document "${document.title}" ?'),
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
              context.read<DocumentBloc>().add(DeleteDocument(document.id));
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

  // Partage un document
  void _shareDocument(BuildContext context, Document document) {
    // Ici, on implémenterait la logique de partage
    // Pour l'instant, on affiche juste un snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Partage du document "${document.title}" (à implémenter)'),
      ),
    );
  }
}
