import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_file.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_item.dart';

/// Widget pour afficher un élément de stockage (fichier ou dossier)
class StorageItemCard extends StatelessWidget {
  final StorageItem item;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onShareToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onRename;
  final VoidCallback? onMove;
  final VoidCallback? onCopy;
  
  const StorageItemCard({
    Key? key,
    required this.item,
    required this.onTap,
    this.onFavoriteToggle,
    this.onShareToggle,
    this.onDelete,
    this.onRename,
    this.onMove,
    this.onCopy,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isFile = item.itemType == StorageItemType.file;
    
    // Determine l'icône et la couleur en fonction du type
    IconData icon;
    Color iconColor;
    
    if (isFile) {
      final fileItem = item as StorageFileItem;
      icon = fileItem.file.type.icon;
      iconColor = fileItem.file.type.color;
    } else {
      icon = Icons.folder;
      iconColor = Colors.amber;
    }
    
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Icône
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 16.0),
              
              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4.0),
                    
                    // Détails supplémentaires pour les fichiers
                    if (isFile)
                      Text(
                        (item as StorageFileItem).file.formattedSize,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    
                    // Nombre d'éléments pour les dossiers
                    if (!isFile)
                      Text(
                        '${(item as StorageFolderItem).folder.itemCount} élément${(item as StorageFolderItem).folder.itemCount > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              
              // Indicateurs (favori, partagé)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.isFavorite)
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20.0,
                    ),
                  
                  if (item.isShared)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.share,
                        color: Colors.blue,
                        size: 20.0,
                      ),
                    ),
                ],
              ),
              
              // Menu contextuel
              _buildPopupMenu(context),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'favorite':
            onFavoriteToggle?.call();
            break;
          case 'share':
            onShareToggle?.call();
            break;
          case 'rename':
            onRename?.call();
            break;
          case 'move':
            onMove?.call();
            break;
          case 'copy':
            onCopy?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'favorite',
          child: ListTile(
            leading: Icon(
              item.isFavorite ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
            title: Text(item.isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
        PopupMenuItem(
          value: 'share',
          child: ListTile(
            leading: Icon(
              item.isShared ? Icons.share : Icons.share_outlined,
              color: Colors.blue,
            ),
            title: Text(item.isShared ? 'Arrêter le partage' : 'Partager'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
        PopupMenuItem(
          value: 'rename',
          child: const ListTile(
            leading: Icon(Icons.edit),
            title: Text('Renommer'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
        PopupMenuItem(
          value: 'move',
          child: const ListTile(
            leading: Icon(Icons.drive_file_move),
            title: Text('Déplacer'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
        if (item.itemType == StorageItemType.file)
          PopupMenuItem(
            value: 'copy',
            child: const ListTile(
              leading: Icon(Icons.copy),
              title: Text('Copier'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            title: const Text('Supprimer'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
      ],
    );
  }
}
