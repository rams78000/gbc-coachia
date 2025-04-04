import 'dart:io';

import 'package:gbc_coachai/features/documents/data/sources/document_local_source.dart';
import 'package:gbc_coachai/features/documents/domain/entities/document.dart';
import 'package:gbc_coachai/features/documents/domain/repositories/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentLocalSource localSource;

  DocumentRepositoryImpl({required this.localSource});

  @override
  Future<List<Document>> getDocuments() async {
    return await localSource.getDocuments();
  }

  @override
  Future<Document?> getDocumentById(String id) async {
    return await localSource.getDocumentById(id);
  }

  @override
  Future<Document> addDocument({
    required String name,
    required String description,
    required File file,
    required DocumentType type,
    List<String> tags = const [],
    String? associatedEntityId,
  }) async {
    return await localSource.saveDocument(
      name,
      description,
      file,
      type,
      tags,
      associatedEntityId,
    );
  }

  @override
  Future<void> updateDocument(Document document) async {
    await localSource.updateDocument(document);
  }

  @override
  Future<void> deleteDocument(String id) async {
    await localSource.deleteDocument(id);
  }

  @override
  Future<List<Document>> getDocumentsByType(DocumentType type) async {
    final documents = await localSource.getDocuments();
    return documents.where((document) => document.type == type).toList();
  }

  @override
  Future<List<Document>> getDocumentsByTag(String tag) async {
    final documents = await localSource.getDocuments();
    return documents.where((document) => document.tags.contains(tag)).toList();
  }

  @override
  Future<List<Document>> getDocumentsByEntityId(String entityId) async {
    final documents = await localSource.getDocuments();
    return documents
        .where((document) => document.associatedEntityId == entityId)
        .toList();
  }

  @override
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    final document = await localSource.getDocumentById(id);
    if (document != null) {
      final updatedDocument = document.copyWith(isFavorite: isFavorite);
      await localSource.updateDocument(updatedDocument);
    } else {
      throw Exception('Document not found');
    }
  }

  @override
  Future<List<Document>> getFavoriteDocuments() async {
    final documents = await localSource.getDocuments();
    return documents.where((document) => document.isFavorite).toList();
  }

  @override
  Future<List<Document>> searchDocuments(String query) async {
    final documents = await localSource.getDocuments();
    final lowercaseQuery = query.toLowerCase();
    
    return documents.where((document) {
      return document.name.toLowerCase().contains(lowercaseQuery) ||
          document.description.toLowerCase().contains(lowercaseQuery) ||
          document.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  @override
  Future<File?> getDocumentFile(String id) async {
    return await localSource.getDocumentFile(id);
  }

  @override
  Future<String?> generateThumbnail(File file, DocumentType type) async {
    return await localSource.generateThumbnail(file, type);
  }

  // Gestion des dossiers

  @override
  Future<List<DocumentFolder>> getFolders() async {
    return await localSource.getFolders();
  }

  @override
  Future<DocumentFolder?> getFolderById(String id) async {
    return await localSource.getFolderById(id);
  }

  @override
  Future<DocumentFolder> createFolder(String name, {String? parentId}) async {
    return await localSource.createFolder(name, parentId: parentId);
  }

  @override
  Future<void> updateFolder(DocumentFolder folder) async {
    await localSource.updateFolder(folder);
  }

  @override
  Future<void> deleteFolder(String id) async {
    await localSource.deleteFolder(id);
  }

  @override
  Future<List<DocumentFolder>> getRootFolders() async {
    final folders = await localSource.getFolders();
    return folders.where((folder) => folder.parentId == null).toList();
  }

  @override
  Future<List<DocumentFolder>> getSubfolders(String folderId) async {
    final folders = await localSource.getFolders();
    return folders.where((folder) => folder.parentId == folderId).toList();
  }

  @override
  Future<List<Document>> getDocumentsInFolder(String folderId) async {
    final folder = await localSource.getFolderById(folderId);
    if (folder == null) {
      throw Exception('Folder not found');
    }
    
    final allDocuments = await localSource.getDocuments();
    return allDocuments
        .where((document) => folder.documentIds.contains(document.id))
        .toList();
  }

  @override
  Future<void> addDocumentToFolder(String documentId, String folderId) async {
    // Vérifier que le document existe
    final document = await localSource.getDocumentById(documentId);
    if (document == null) {
      throw Exception('Document not found');
    }
    
    // Vérifier que le dossier existe
    final folder = await localSource.getFolderById(folderId);
    if (folder == null) {
      throw Exception('Folder not found');
    }
    
    // Ajouter le document au dossier s'il n'y est pas déjà
    if (!folder.documentIds.contains(documentId)) {
      final updatedFolder = folder.copyWith(
        documentIds: [...folder.documentIds, documentId],
        modifiedAt: DateTime.now(),
      );
      await localSource.updateFolder(updatedFolder);
    }
  }

  @override
  Future<void> removeDocumentFromFolder(String documentId, String folderId) async {
    // Vérifier que le dossier existe
    final folder = await localSource.getFolderById(folderId);
    if (folder == null) {
      throw Exception('Folder not found');
    }
    
    // Supprimer le document du dossier s'il y est
    if (folder.documentIds.contains(documentId)) {
      final updatedFolder = folder.copyWith(
        documentIds: List.from(folder.documentIds)..remove(documentId),
        modifiedAt: DateTime.now(),
      );
      await localSource.updateFolder(updatedFolder);
    }
  }
}
