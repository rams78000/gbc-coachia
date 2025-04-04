import 'dart:io';

import 'package:gbc_coachia/features/documents/domain/entities/document.dart';

abstract class DocumentRepository {
  /// Récupère tous les documents
  Future<List<Document>> getDocuments();
  
  /// Récupère un document par son ID
  Future<Document?> getDocumentById(String id);
  
  /// Ajoute un nouveau document
  Future<Document> addDocument({
    required String name,
    required String description,
    required File file,
    required DocumentType type,
    List<String> tags = const [],
    String? associatedEntityId,
  });
  
  /// Met à jour un document existant
  Future<void> updateDocument(Document document);
  
  /// Supprime un document
  Future<void> deleteDocument(String id);
  
  /// Récupère les documents par type
  Future<List<Document>> getDocumentsByType(DocumentType type);
  
  /// Récupère les documents par tag
  Future<List<Document>> getDocumentsByTag(String tag);
  
  /// Récupère les documents associés à une entité
  Future<List<Document>> getDocumentsByEntityId(String entityId);
  
  /// Marque un document comme favori
  Future<void> toggleFavorite(String id, bool isFavorite);
  
  /// Récupère les documents favoris
  Future<List<Document>> getFavoriteDocuments();
  
  /// Recherche des documents par mot-clé
  Future<List<Document>> searchDocuments(String query);
  
  /// Récupère le fichier local d'un document
  Future<File?> getDocumentFile(String id);
  
  /// Génère une miniature pour un document (si applicable)
  Future<String?> generateThumbnail(File file, DocumentType type);
  
  // Gestion des dossiers
  
  /// Récupère tous les dossiers
  Future<List<DocumentFolder>> getFolders();
  
  /// Récupère un dossier par son ID
  Future<DocumentFolder?> getFolderById(String id);
  
  /// Crée un nouveau dossier
  Future<DocumentFolder> createFolder(String name, {String? parentId});
  
  /// Met à jour un dossier existant
  Future<void> updateFolder(DocumentFolder folder);
  
  /// Supprime un dossier
  Future<void> deleteFolder(String id);
  
  /// Récupère les dossiers racines
  Future<List<DocumentFolder>> getRootFolders();
  
  /// Récupère les sous-dossiers d'un dossier
  Future<List<DocumentFolder>> getSubfolders(String folderId);
  
  /// Récupère les documents d'un dossier
  Future<List<Document>> getDocumentsInFolder(String folderId);
  
  /// Ajoute un document à un dossier
  Future<void> addDocumentToFolder(String documentId, String folderId);
  
  /// Supprime un document d'un dossier
  Future<void> removeDocumentFromFolder(String documentId, String folderId);
}
