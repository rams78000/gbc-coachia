import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:intl/intl.dart';

class RecentDocumentsCard extends StatelessWidget {
  final List<Document> documents;
  final VoidCallback onTap;
  final Function(Document) onDocumentTap;

  const RecentDocumentsCard({
    Key? key,
    required this.documents,
    required this.onTap,
    required this.onDocumentTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.insert_drive_file,
                        color: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Documents récents',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.colorScheme.tertiary,
                  ),
                ],
              ),
            ),
            
            // Document List
            SizedBox(
              height: 250,
              child: documents.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: documents.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return _buildDocumentItem(
                          context,
                          documents[index],
                          onTap: () => onDocumentTap(documents[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun document récent',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les documents que vous ajoutez apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(
    BuildContext context,
    Document document, {
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMM yyyy', 'fr_FR');
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Document type icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getDocumentTypeColor(document.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getDocumentTypeIcon(document.type),
                color: _getDocumentTypeColor(document.type),
                size: 20,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Document info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateFormat.format(document.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.straighten,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatFileSize(document.size),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  if (document.tags.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: document.tags
                          .take(2)
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            
            // Favorite indicator
            if (document.isFavorite)
              Icon(
                Icons.star,
                color: Colors.amber[700],
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Color _getDocumentTypeColor(DocumentType type) {
    switch (type) {
      case DocumentType.invoice:
        return Colors.green;
      case DocumentType.contract:
        return Colors.purple;
      case DocumentType.report:
        return Colors.blue;
      case DocumentType.receipt:
        return Colors.amber;
      case DocumentType.proposal:
        return Colors.deepOrange;
      case DocumentType.legal:
        return Colors.red;
      case DocumentType.tax:
        return Colors.brown;
      case DocumentType.image:
        return Colors.lightBlue;
      case DocumentType.pdf:
        return Colors.red;
      case DocumentType.spreadsheet:
        return Colors.green;
      case DocumentType.presentation:
        return Colors.orange;
      case DocumentType.text:
        return Colors.indigo;
      case DocumentType.other:
        return Colors.grey;
    }
  }

  IconData _getDocumentTypeIcon(DocumentType type) {
    switch (type) {
      case DocumentType.invoice:
        return Icons.receipt_long;
      case DocumentType.contract:
        return Icons.description;
      case DocumentType.report:
        return Icons.assessment;
      case DocumentType.receipt:
        return Icons.receipt;
      case DocumentType.proposal:
        return Icons.lightbulb;
      case DocumentType.legal:
        return Icons.gavel;
      case DocumentType.tax:
        return Icons.account_balance;
      case DocumentType.image:
        return Icons.image;
      case DocumentType.pdf:
        return Icons.picture_as_pdf;
      case DocumentType.spreadsheet:
        return Icons.table_chart;
      case DocumentType.presentation:
        return Icons.slideshow;
      case DocumentType.text:
        return Icons.article;
      case DocumentType.other:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double size = bytes.toDouble();
    
    while (size > 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }
}
