import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_extensions.dart';
import 'package:gbc_coachia/features/documents/presentation/bloc/document_bloc.dart';
import 'package:gbc_coachia/features/documents/presentation/widgets/document_preview.dart';
import 'package:gbc_coachia/features/shared/presentation/widgets/main_scaffold.dart';

/// Page affichant le détail d'un document
class DocumentDetailPage extends StatefulWidget {
  final String documentId;

  const DocumentDetailPage({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  @override
  State<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends State<DocumentDetailPage> {
  late Document _document;
  bool _isLoaded = false;
  
  @override
  void initState() {
    super.initState();
    
    // Charger le document
    context.read<DocumentBloc>().add(LoadDocumentById(widget.documentId));
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: _isLoaded ? _document.title : 'Détail du document',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: _isLoaded ? [
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _editDocument();
                break;
              case 'delete':
                _showDeleteConfirmationDialog();
                break;
              case 'status':
                _showStatusChangeDialog();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8.0),
                  Text('Modifier'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'status',
              child: Row(
                children: [
                  Icon(Icons.sync),
                  SizedBox(width: 8.0),
                  Text('Changer le statut'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  const SizedBox(width: 8.0),
                  const Text('Supprimer', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ] : null,
      body: BlocBuilder<DocumentBloc, DocumentState>(
        builder: (context, state) {
          if (state is DocumentsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DocumentLoaded) {
            // Stocker le document pour l'accès dans d'autres méthodes
            _document = state.document;
            _isLoaded = true;
            
            return _buildDocumentDetail();
          } else if (state is DocumentsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erreur: ${state.message}'),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DocumentBloc>().add(LoadDocumentById(widget.documentId));
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          
          return const Center(
            child: Text('Chargement du document...'),
          );
        },
      ),
    );
  }

  // Construit le détail du document
  Widget _buildDocumentDetail() {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // En-tête avec informations principales
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(_document.type.color).withOpacity(0.1),
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor,
                width: 1.0,
              ),
            ),
          ),
          child: Column(
            children: [
              // Type et statut
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: Color(_document.type.color),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        _document.type.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Color(_document.type.color),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: Color(_document.status.color),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      _document.status.displayName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16.0),
              
              // Dates
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.calendar_today,
                      label: 'Créé le',
                      value: _document.formattedCreatedAt,
                    ),
                  ),
                  if (_document.updatedAt != null)
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        icon: Icons.update,
                        label: 'Mis à jour le',
                        value: _document.formattedUpdatedAt!,
                      ),
                    ),
                  if (_document.expiryDate != null)
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        icon: Icons.timer,
                        label: 'Expire le',
                        value: _document.formattedExpiryDate!,
                        isAlert: _document.isExpired,
                      ),
                    ),
                ],
              ),
              
              // Destinataire si présent
              if (_document.hasRecipient) ...[
                const SizedBox(height: 16.0),
                _buildInfoItem(
                  context,
                  icon: Icons.person,
                  label: 'Destinataire',
                  value: '${_document.recipientName} <${_document.recipientEmail}>',
                ),
              ],
            ],
          ),
        ),
        
        // Aperçu du document
        Expanded(
          child: DocumentPreview(
            document: _document,
            showJsonView: false,
            onDownload: _downloadDocument,
            onShare: _shareDocument,
          ),
        ),
      ],
    );
  }

  // Construit un élément d'information
  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isAlert = false,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          size: 18.0,
          color: isAlert ? Colors.red : theme.colorScheme.primary,
        ),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isAlert ? Colors.red : theme.colorScheme.onSurface,
                fontWeight: isAlert ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Télécharge le document
  void _downloadDocument() {
    // Ici, on implémenterait la logique de téléchargement
    // Pour l'instant, on affiche juste un snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Téléchargement du document (à implémenter)'),
      ),
    );
  }

  // Partage le document
  void _shareDocument() {
    // Ici, on implémenterait la logique de partage
    // Pour l'instant, on affiche juste un snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Partage du document (à implémenter)'),
      ),
    );
  }

  // Édite le document
  void _editDocument() {
    Navigator.pushNamed(
      context,
      '/documents/edit',
      arguments: _document.id,
    );
  }

  // Affiche une boîte de dialogue de confirmation pour la suppression
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer le document "${_document.title}" ?'),
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
              
              // Supprimer le document
              context.read<DocumentBloc>().add(DeleteDocument(_document.id));
              
              // Retourner à la liste des documents
              Navigator.pop(context);
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

  // Affiche une boîte de dialogue pour changer le statut du document
  void _showStatusChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le statut'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: DocumentStatus.values.length,
            itemBuilder: (context, index) {
              final status = DocumentStatus.values[index];
              final isSelected = status == _document.status;
              
              return ListTile(
                title: Text(status.displayName),
                leading: CircleAvatar(
                  backgroundColor: Color(status.color),
                  radius: 12.0,
                ),
                trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () {
                  Navigator.pop(context);
                  
                  if (!isSelected) {
                    // Changer le statut du document
                    context.read<DocumentBloc>().add(ChangeDocumentStatus(_document.id, status));
                    
                    // Recharger le document
                    context.read<DocumentBloc>().add(LoadDocumentById(_document.id));
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }
}
