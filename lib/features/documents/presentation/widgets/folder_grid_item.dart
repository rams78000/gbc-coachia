import 'package:flutter/material.dart';
import 'package:gbc_coachai/features/documents/domain/entities/document.dart';
import 'package:intl/intl.dart';

class FolderGridItem extends StatelessWidget {
  final DocumentFolder folder;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const FolderGridItem({
    super.key,
    required this.folder,
    required this.onTap,
    this.onEdit,
    this.onDelete,
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
          children: [
            // Folder icon
            Expanded(
              child: Container(
                color: Colors.amber.withOpacity(0.1),
                child: Center(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.folder,
                        size: 80,
                        color: Colors.amber,
                      ),
                      if (folder.documentIds.isNotEmpty)
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${folder.documentIds.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Folder name and options
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          folder.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onEdit != null || onDelete != null)
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          onSelected: (value) {
                            if (value == 'edit' && onEdit != null) {
                              onEdit!();
                            } else if (value == 'delete' && onDelete != null) {
                              onDelete!();
                            }
                          },
                          itemBuilder: (context) => [
                            if (onEdit != null)
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 18),
                                    SizedBox(width: 8),
                                    Text('Renommer'),
                                  ],
                                ),
                              ),
                            if (onDelete != null)
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 18),
                                    SizedBox(width: 8),
                                    Text('Supprimer'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd/MM/yyyy').format(folder.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.folder,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${folder.subfolderIds.length} sous-dossier${folder.subfolderIds.length != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.insert_drive_file,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${folder.documentIds.length} fichier${folder.documentIds.length != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
