import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_extensions.dart';

/// Carte représentant un document dans une liste
class DocumentCard extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DocumentCard({
    Key? key,
    required this.document,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec titre et actions
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      document.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onEdit != null || onDelete != null)
                    _buildPopupMenu(context),
                ],
              ),
            ),
            
            // Infos du document
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type et statut
                  Row(
                    children: [
                      // Type
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Color(document.type.color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.description,
                              size: 14.0,
                              color: Color(document.type.color),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              document.type.displayName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Color(document.type.color),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 8.0),
                      
                      // Statut
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Color(document.status.color),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          document.status.displayName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Date de création
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14.0,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            document.formattedCreatedAt,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12.0),
                  
                  // Contenu du document (aperçu)
                  if (document.contentPreview.isNotEmpty) ...[
                    Text(
                      document.contentPreview,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12.0),
                  ],
                  
                  // Destinataire si présent
                  if (document.hasRecipient) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 14.0,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            '${document.recipientName}${document.recipientEmail.isNotEmpty ? ' <${document.recipientEmail}>' : ''}',
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  // Date d'expiration si présente
                  if (document.expiryDate != null) ...[
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 14.0,
                          color: document.isExpired ? Colors.red : Colors.orange,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          document.isExpired
                              ? 'Expiré le ${document.formattedExpiryDate}'
                              : 'Expire le ${document.formattedExpiryDate}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: document.isExpired ? Colors.red : Colors.orange,
                            fontWeight: document.isExpired ? FontWeight.bold : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Construit le menu popup
  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        if (onEdit != null)
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
        if (onDelete != null)
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
    );
  }
}
