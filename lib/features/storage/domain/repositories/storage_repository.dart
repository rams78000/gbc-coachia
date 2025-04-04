import 'dart:typed_data';

import 'package:gbc_coachia/features/storage/domain/entities/storage_file.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_folder.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_item.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_statistics.dart';

/// Contrat pour le repository de stockage
abstract class StorageRepository {
  /// Obtient la liste des éléments (fichiers et dossiers) dans un dossier donné
  Future<List<StorageItem>> getItemsInFolder(String folderId);
  
  /// Obtient la liste des fichiers récents
  Future<List<StorageFile>> getRecentFiles({int limit = 10});
  
  /// Obtient la liste des fichiers favoris
  Future<List<StorageFile>> getFavoriteFiles();
  
  /// Obtient la liste des fichiers partagés
  Future<List<StorageFile>> getSharedFiles();
  
  /// Obtient un fichier par son ID
  Future<StorageFile> getFileById(String id);
  
  /// Obtient un dossier par son ID
  Future<StorageFolder> getFolderById(String id);
  
  /// Crée un nouveau dossier
  Future<StorageFolder> createFolder({
    required String name,
    required String parentId,
  });
  
  /// Renomme un fichier
  Future<StorageFile> renameFile({
    required String id,
    required String newName,
  });
  
  /// Renomme un dossier
  Future<StorageFolder> renameFolder({
    required String id,
    required String newName,
  });
  
  /// Déplace un fichier
  Future<StorageFile> moveFile({
    required String id,
    required String destinationFolderId,
  });
  
  /// Déplace un dossier
  Future<StorageFolder> moveFolder({
    required String id,
    required String destinationFolderId,
  });
  
  /// Marque un fichier comme favori
  Future<StorageFile> toggleFileFavorite({
    required String id,
    required bool isFavorite,
  });
  
  /// Marque un dossier comme favori
  Future<StorageFolder> toggleFolderFavorite({
    required String id,
    required bool isFavorite,
  });
  
  /// Partage un fichier
  Future<StorageFile> toggleFileSharing({
    required String id,
    required bool isShared,
  });
  
  /// Partage un dossier
  Future<StorageFolder> toggleFolderSharing({
    required String id,
    required bool isShared,
  });
  
  /// Supprime un fichier
  Future<void> deleteFile(String id);
  
  /// Supprime un dossier
  Future<void> deleteFolder(String id);
  
  /// Télécharge un fichier
  Future<Uint8List> downloadFile(String id);
  
  /// Téléverse un fichier
  Future<StorageFile> uploadFile({
    required String name,
    required String folderId,
    required Uint8List data,
    String? contentType,
  });
  
  /// Recherche des fichiers et dossiers
  Future<List<StorageItem>> searchItems(String query);
  
  /// Filtre les fichiers par type
  Future<List<StorageFile>> filterFilesByType(FileType type);
  
  /// Obtient les statistiques de stockage
  Future<StorageStatistics> getStorageStatistics();
  
  /// Obtient un aperçu du contenu d'un fichier
  Future<Uint8List?> getFilePreview(String id);
  
  /// Obtient les informations sur le chemin d'accès pour la navigation (breadcrumb)
  Future<List<StorageFolder>> getPathInfo(String folderId);
  
  /// Copie un fichier
  Future<StorageFile> copyFile({
    required String id,
    required String destinationFolderId,
  });
}
