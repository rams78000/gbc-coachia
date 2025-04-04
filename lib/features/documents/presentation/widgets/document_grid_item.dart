import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gbc_coachai/features/documents/domain/entities/document.dart';
import 'package:intl/intl.dart';

class DocumentGridItem extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onToggleFavorite;

  const DocumentGridItem({
    super.key,
    required this.document,
    required this.onTap,
    this.onDelete,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail or Icon
            Stack(
              children: [
                _buildThumbnail(context),
                // Favorite button
                if (onToggleFavorite != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          document.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: document.isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          onToggleFavorite!(!document.isFavorite);
                        },
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minHeight: 36,
                          minWidth: 36,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Document info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          _getDocumentTypeIcon(document.type),
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _formatFileSize(document.size),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy').format(document.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (document.tags.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: document.tags
                            .take(2)
                            .map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Actions
            if (onDelete != null)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: onDelete,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minHeight: 36,
                        minWidth: 36,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    if (document.thumbnailPath != null) {
      // Afficher la miniature si elle existe
      return Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Image.file(
          File(document.thumbnailPath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackThumbnail();
          },
        ),
      );
    } else {
      return _buildFallbackThumbnail();
    }
  }

  Widget _buildFallbackThumbnail() {
    return Container(
      height: 120,
      width: double.infinity,
      color: _getDocumentTypeColor(document.type).withOpacity(0.2),
      child: Center(
        child: Icon(
          _getDocumentTypeIcon(document.type),
          size: 48,
          color: _getDocumentTypeColor(document.type),
        ),
      ),
    );
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
        return Icons.insert_drive_file;
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

  Color _getDocumentTypeColor(DocumentType type) {
    switch (type) {
      case DocumentType.invoice:
      case DocumentType.receipt:
        return Colors.green;
      case DocumentType.contract:
      case DocumentType.legal:
        return Colors.blue;
      case DocumentType.report:
      case DocumentType.tax:
        return Colors.purple;
      case DocumentType.proposal:
        return Colors.orange;
      case DocumentType.image:
        return Colors.pink;
      case DocumentType.pdf:
        return Colors.red;
      case DocumentType.spreadsheet:
        return Colors.green;
      case DocumentType.presentation:
        return Colors.amber;
      case DocumentType.text:
        return Colors.teal;
      case DocumentType.other:
        return Colors.grey;
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
