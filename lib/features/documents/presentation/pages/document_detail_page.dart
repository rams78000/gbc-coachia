import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/presentation/bloc/document_bloc.dart';
import 'package:intl/intl.dart';

/// Page de détail d'un document
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
  @override
  void initState() {
    super.initState();
    // Charger le document
    context.read<DocumentBloc>().add(LoadDocumentById(widget.documentId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail du document'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implémenter le partage
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Partage non implémenté'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showOptionsBottomSheet(context);
            },
          ),
        ],
      ),
      body: BlocConsumer<DocumentBloc, DocumentState>(
        listener: (context, state) {
          if (state is DocumentsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DocumentLoaded) {
            final document = state.document;
            return _buildDocumentDetails(context, document);
          }
          
          if (state is DocumentsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          return const Center(
            child: Text('Chargement du document...'),
          );
        },
      ),
    );
  }
  
  // Construit le contenu de la page
  Widget _buildDocumentDetails(BuildContext context, Document document) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    // Formater le montant s'il existe
    String? formattedAmount;
    if (document.amount != null && document.currency != null) {
      final numberFormat = NumberFormat.currency(
        symbol: _getCurrencySymbol(document.currency!),
        decimalDigits: 2,
      );
      formattedAmount = numberFormat.format(document.amount);
    }
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec couleur du type de document
          Container(
            width: double.infinity,
            color: document.type.color.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type et statut
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: document.type.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            document.type.icon,
                            size: 16.0,
                            color: document.type.color,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            document.type.displayName,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: document.type.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 8.0),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: document.status.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            document.status.icon,
                            size: 16.0,
                            color: document.status.color,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            document.status.displayName,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: document.status.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12.0),
                
                // Titre du document
                Text(
                  document.title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12.0),
                
                // Informations de base
                if (document.clientName != null)
                  _buildInfoRow(
                    context,
                    Icons.person,
                    'Client:',
                    document.clientName!,
                  ),
                
                if (formattedAmount != null)
                  _buildInfoRow(
                    context,
                    Icons.monetization_on,
                    'Montant:',
                    formattedAmount,
                  ),
                
                _buildInfoRow(
                  context,
                  Icons.calendar_today,
                  'Créé le:',
                  dateFormat.format(document.createdAt),
                ),
                
                if (document.updatedAt != null)
                  _buildInfoRow(
                    context,
                    Icons.update,
                    'Mis à jour le:',
                    dateFormat.format(document.updatedAt!),
                  ),
                
                if (document.expiresAt != null)
                  _buildInfoRow(
                    context,
                    Icons.timelapse,
                    'Expire le:',
                    dateFormat.format(document.expiresAt!),
                    textColor: _isExpired(document.expiresAt!) ? Colors.red : null,
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 16.0),
          
          // Actions rapides
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  Icons.download,
                  'Télécharger',
                  onPressed: () {
                    // TODO: Implémenter le téléchargement
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Téléchargement non implémenté'),
                      ),
                    );
                  },
                ),
                
                _buildActionButton(
                  context,
                  Icons.edit,
                  'Modifier',
                  onPressed: () {
                    // TODO: Implémenter la modification
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Modification non implémentée'),
                      ),
                    );
                  },
                ),
                
                _buildActionButton(
                  context,
                  Icons.share,
                  'Partager',
                  onPressed: () {
                    // TODO: Implémenter le partage
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Partage non implémenté'),
                      ),
                    );
                  },
                ),
                
                _buildActionButton(
                  context,
                  document.status.icon,
                  'Statut',
                  onPressed: () {
                    _showStatusChangeDialog(context, document);
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24.0),
          
          // Aperçu du document
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Aperçu du document',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 16.0),
          
          // Contenu du document (simplifié)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.content,
                  style: const TextStyle(fontSize: 14.0),
                ),
                
                const SizedBox(height: 16.0),
                
                // Bouton pour voir le document complet
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implémenter l'affichage du document complet
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Affichage du document complet non implémenté'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('Voir le document complet'),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24.0),
          
          // Données du document
          if (document.data.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Données du document',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 16.0),
            
            // Liste des données
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: document.data.entries.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    final entry = document.data.entries.elementAt(index);
                    return ListTile(
                      title: Text(
                        _formatKey(entry.key),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      subtitle: Text(
                        _formatValue(entry.value),
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      dense: true,
                    );
                  },
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
  
  // Construit une ligne d'information
  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.0,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8.0),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: textColor ?? Colors.grey[800],
                fontWeight: textColor != null ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Construit un bouton d'action
  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label, {
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Affiche la boîte de dialogue pour changer le statut
  void _showStatusChangeDialog(BuildContext context, Document document) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Changer le statut'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: DocumentStatus.values.length,
              itemBuilder: (context, index) {
                final status = DocumentStatus.values[index];
                final isSelected = status == document.status;
                
                return ListTile(
                  leading: Icon(
                    status.icon,
                    color: status.color,
                  ),
                  title: Text(status.displayName),
                  trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                  onTap: isSelected
                      ? null
                      : () {
                          Navigator.pop(context);
                          
                          // Mettre à jour le statut
                          context.read<DocumentBloc>().add(
                                ChangeDocumentStatus(document.id, status),
                              );
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
        );
      },
    );
  }
  
  // Affiche la feuille d'options
  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Modifier'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implémenter la modification
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Modification non implémentée'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_copy),
                title: const Text('Dupliquer'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implémenter la duplication
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Duplication non implémentée'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Exporter en PDF'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implémenter l'exportation en PDF
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exportation en PDF non implémentée'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmationDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Affiche la boîte de dialogue de confirmation de suppression
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce document ? Cette action est irréversible.'),
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
                context.read<DocumentBloc>().add(DeleteDocument(widget.documentId));
                // Retourner à la page précédente
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
  
  // Vérifie si une date est expirée
  bool _isExpired(DateTime date) {
    return date.isBefore(DateTime.now());
  }
  
  // Obtient le symbole de la devise
  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'EUR':
        return '€';
      case 'USD':
        return '\$';
      case 'GBP':
        return '£';
      case 'CAD':
        return 'CA\$';
      default:
        return currency;
    }
  }
  
  // Formate une clé pour l'affichage
  String _formatKey(String key) {
    // Convertir camelCase en mots séparés par des espaces avec majuscule
    final result = key.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );
    
    return result.substring(0, 1).toUpperCase() + result.substring(1);
  }
  
  // Formate une valeur pour l'affichage
  String _formatValue(dynamic value) {
    if (value == null) {
      return 'Non spécifié';
    }
    
    if (value is String) {
      // Si c'est une date ISO 8601
      if (value.contains('T') && value.contains('-') && value.length > 10) {
        try {
          final date = DateTime.parse(value);
          return DateFormat('dd/MM/yyyy').format(date);
        } catch (e) {
          return value;
        }
      }
      return value;
    }
    
    if (value is bool) {
      return value ? 'Oui' : 'Non';
    }
    
    if (value is Map || value is List) {
      return '(Données complexes)';
    }
    
    return value.toString();
  }
}
