import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_file.dart';

/// Dialog pour prévisualiser un fichier
class FilePreviewDialog extends StatelessWidget {
  final StorageFile file;
  final Uint8List? previewData;
  
  const FilePreviewDialog({
    Key? key,
    required this.file,
    required this.previewData,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // En-tête
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      file.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            
            // Contenu
            Flexible(
              child: _buildPreviewContent(context),
            ),
            
            // Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('Télécharger'),
                    onPressed: () {
                      // TODO: Implémenter le téléchargement
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Téléchargement non implémenté'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8.0),
                  TextButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text('Partager'),
                    onPressed: () {
                      // TODO: Implémenter le partage
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Partage non implémenté'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPreviewContent(BuildContext context) {
    if (previewData == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              file.type.icon,
              size: 64.0,
              color: file.type.color,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Aperçu non disponible',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Le fichier "${file.extension}" ne peut pas être prévisualisé.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    // En fonction du type de fichier, afficher la prévisualisation appropriée
    switch (file.type) {
      case FileType.image:
        return InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Image.memory(
                previewData!,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
        
      case FileType.pdf:
        return const Center(
          child: Text('Prévisualisation PDF non implémentée'),
        );
        
      case FileType.document:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Contenu du document non implémenté.\n\n'
            'Ceci est un exemple de texte pour simuler le contenu d\'un document.\n\n'
            'Le contenu réel du document serait affiché ici.',
          ),
        );
        
      case FileType.video:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.videocam,
                size: 64.0,
                color: Colors.red,
              ),
              SizedBox(height: 16.0),
              Text(
                'Lecteur vidéo non implémenté',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        
      default:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                file.type.icon,
                size: 64.0,
                color: file.type.color,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Aperçu non disponible',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
    }
  }
}
