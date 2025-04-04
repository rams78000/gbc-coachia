import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_file.dart';
import 'package:gbc_coachia/features/storage/presentation/bloc/storage_bloc.dart';
import 'package:intl/intl.dart';

/// Page de détails d'un fichier
class FileDetailsPage extends StatelessWidget {
  final String fileId;
  
  const FileDetailsPage({
    Key? key,
    required this.fileId,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Charger les détails du fichier
    context.read<StorageBloc>().add(LoadFilePreview(fileId));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du fichier'),
        actions: [
          // Menu d'options
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'download':
                  context.read<StorageBloc>().add(DownloadFile(fileId));
                  break;
                case 'share':
                  // TODO: Implémenter le partage
                  break;
                case 'delete':
                  _showDeleteConfirmationDialog(context, fileId);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'download',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Télécharger'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Partager'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Supprimer'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<StorageBloc, StorageState>(
        listener: (context, state) {
          if (state is FileDeleted) {
            // Fichier supprimé, retourner à l'écran précédent
            Navigator.pop(context);
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fichier supprimé avec succès'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is FileDownloaded) {
            // Fichier téléchargé avec succès
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Fichier "${state.file.name}" téléchargé avec succès'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is StorageError) {
            // Erreur
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FilePreviewLoaded) {
            final file = state.file;
            
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Aperçu du fichier
                  _buildFilePreview(context, file, state.data),
                  
                  // Métadonnées du fichier
                  _buildFileMetadata(context, file),
                ],
              ),
            );
          }
          
          if (state is FilePreviewLoading || state is StorageLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return const Center(child: Text('Chargement des détails du fichier...'));
        },
      ),
    );
  }
  
  // Construit l'aperçu du fichier
  Widget _buildFilePreview(BuildContext context, StorageFile file, Uint8List? data) {
    // Hauteur fixe pour la zone d'aperçu
    final previewHeight = MediaQuery.of(context).size.height * 0.4;
    
    if (!file.isPreviewable || data == null) {
      // Pas d'aperçu disponible
      return Container(
        height: previewHeight,
        color: Colors.grey[100],
        child: Center(
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
        ),
      );
    }
    
    // En fonction du type de fichier, afficher l'aperçu approprié
    switch (file.type) {
      case FileType.image:
        return Container(
          height: previewHeight,
          width: double.infinity,
          color: Colors.black,
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.memory(
              data,
              fit: BoxFit.contain,
            ),
          ),
        );
        
      case FileType.pdf:
        return Container(
          height: previewHeight,
          color: Colors.grey[100],
          child: const Center(
            child: Text('Aperçu PDF non implémenté'),
          ),
        );
        
      case FileType.video:
        return Container(
          height: previewHeight,
          color: Colors.black,
          child: const Center(
            child: Icon(
              Icons.play_circle_filled,
              size: 64.0,
              color: Colors.white,
            ),
          ),
        );
        
      case FileType.document:
        return Container(
          height: previewHeight,
          padding: const EdgeInsets.all(16.0),
          color: Colors.grey[100],
          child: const Center(
            child: Text(
              'Aperçu de document non implémenté.\n\n'
              'Le contenu du document serait affiché ici.',
              textAlign: TextAlign.center,
            ),
          ),
        );
        
      default:
        return Container(
          height: previewHeight,
          color: Colors.grey[100],
          child: Center(
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
          ),
        );
    }
  }
  
  // Construit les métadonnées du fichier
  Widget _buildFileMetadata(BuildContext context, StorageFile file) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom du fichier et icône
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: file.type.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    file.type.icon,
                    color: file.type.color,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16.0),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        file.type.displayName,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const Divider(height: 32.0),
            
            // Informations détaillées
            _buildInfoRow('Taille', file.formattedSize),
            _buildInfoRow('Chemin', file.path),
            _buildInfoRow('Date de création', dateFormat.format(file.createdAt)),
            
            if (file.updatedAt != null)
              _buildInfoRow('Dernière modification', dateFormat.format(file.updatedAt!)),
            
            _buildInfoRow('Favori', file.isFavorite ? 'Oui' : 'Non'),
            _buildInfoRow('Partagé', file.isShared ? 'Oui' : 'Non'),
            
            if (file.url != null)
              _buildInfoRow('URL', file.url!),
            
            const SizedBox(height: 16.0),
            
            // Boutons d'action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  Icons.star,
                  file.isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                  file.isFavorite ? Colors.amber : Colors.grey,
                  () {
                    context.read<StorageBloc>().add(
                      ToggleFileFavorite(
                        id: file.id,
                        isFavorite: !file.isFavorite,
                      ),
                    );
                  },
                ),
                
                _buildActionButton(
                  context,
                  Icons.share,
                  file.isShared ? 'Arrêter le partage' : 'Partager',
                  file.isShared ? Colors.blue : Colors.grey,
                  () {
                    context.read<StorageBloc>().add(
                      ToggleFileSharing(
                        id: file.id,
                        isShared: !file.isShared,
                      ),
                    );
                  },
                ),
                
                _buildActionButton(
                  context,
                  Icons.edit,
                  'Renommer',
                  Colors.grey,
                  () {
                    _showRenameDialog(context, file);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // Construit une ligne d'information
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.0,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  // Construit un bouton d'action
  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
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
              color: color,
              size: 24.0,
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  // Affiche la boîte de dialogue de suppression
  void _showDeleteConfirmationDialog(BuildContext context, String fileId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer ce fichier ?',
        ),
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
              context.read<StorageBloc>().add(DeleteFile(fileId));
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
  
  // Affiche la boîte de dialogue de renommage
  void _showRenameDialog(BuildContext context, StorageFile file) {
    final controller = TextEditingController(text: file.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renommer le fichier'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nouveau nom',
            hintText: 'Entrez le nouveau nom',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              
              if (newName.isEmpty) {
                return;
              }
              
              Navigator.pop(context);
              context.read<StorageBloc>().add(
                RenameFile(
                  id: file.id,
                  newName: newName,
                ),
              );
            },
            child: const Text('Renommer'),
          ),
        ],
      ),
    );
  }
}
