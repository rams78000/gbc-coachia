import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';

abstract class DocumentLocalSource {
  Future<List<Document>> getDocuments();
  Future<Document?> getDocumentById(String id);
  Future<Document> saveDocument(String name, String description, File file, DocumentType type, List<String> tags, String? associatedEntityId);
  Future<void> updateDocument(Document document);
  Future<void> deleteDocument(String id);
  Future<File?> getDocumentFile(String id);
  Future<String?> generateThumbnail(File file, DocumentType type);
  
  // Gestion des dossiers
  Future<List<DocumentFolder>> getFolders();
  Future<DocumentFolder?> getFolderById(String id);
  Future<DocumentFolder> createFolder(String name, {String? parentId});
  Future<void> updateFolder(DocumentFolder folder);
  Future<void> deleteFolder(String id);
}

class DocumentLocalSourceImpl implements DocumentLocalSource {
  final SharedPreferences sharedPreferences;
  static const String _documentsKey = 'documents';
  static const String _foldersKey = 'document_folders';

  DocumentLocalSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Document>> getDocuments() async {
    final documentsJson = sharedPreferences.getStringList(_documentsKey) ?? [];
    return documentsJson
        .map((json) => Document.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<Document?> getDocumentById(String id) async {
    final documents = await getDocuments();
    try {
      return documents.firstWhere((document) => document.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Document> saveDocument(
    String name,
    String description,
    File file,
    DocumentType type,
    List<String> tags,
    String? associatedEntityId,
  ) async {
    // Obtenir le répertoire de stockage
    final documentsDir = await _getDocumentsDirectory();
    
    // Créer un nom de fichier unique basé sur l'horodatage et le nom original
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = path.extension(file.path);
    final fileName = '${timestamp}_${path.basenameWithoutExtension(name)}$extension';
    
    // Chemin de destination
    final destinationPath = path.join(documentsDir.path, fileName);
    
    // Copier le fichier dans notre espace de stockage
    final savedFile = await file.copy(destinationPath);
    
    // Générer une miniature si possible
    final thumbnailPath = await generateThumbnail(savedFile, type);
    
    // Créer l'entité Document
    final document = Document.create(
      name: name,
      description: description,
      path: savedFile.path,
      type: type,
      tags: tags,
      size: await savedFile.length(),
      thumbnailPath: thumbnailPath,
      associatedEntityId: associatedEntityId,
    );
    
    // Sauvegarder dans SharedPreferences
    final documents = await getDocuments();
    documents.add(document);
    await _saveDocuments(documents);
    
    return document;
  }

  @override
  Future<void> updateDocument(Document document) async {
    final documents = await getDocuments();
    final index = documents.indexWhere((d) => d.id == document.id);
    
    if (index != -1) {
      // Mettre à jour le document avec la date de modification
      final updatedDocument = document.copyWith(
        modifiedAt: DateTime.now(),
      );
      
      documents[index] = updatedDocument;
      await _saveDocuments(documents);
    } else {
      throw Exception('Document not found');
    }
  }

  @override
  Future<void> deleteDocument(String id) async {
    final documents = await getDocuments();
    final documentToDelete = documents.firstWhere(
      (document) => document.id == id,
      orElse: () => throw Exception('Document not found'),
    );
    
    // Supprimer le fichier physique
    final file = File(documentToDelete.path);
    if (await file.exists()) {
      await file.delete();
    }
    
    // Supprimer la miniature si elle existe
    if (documentToDelete.thumbnailPath != null) {
      final thumbnailFile = File(documentToDelete.thumbnailPath!);
      if (await thumbnailFile.exists()) {
        await thumbnailFile.delete();
      }
    }
    
    // Supprimer la référence du document dans tous les dossiers
    final folders = await getFolders();
    for (final folder in folders) {
      if (folder.documentIds.contains(id)) {
        final updatedFolder = folder.copyWith(
          documentIds: List.from(folder.documentIds)..remove(id),
          modifiedAt: DateTime.now(),
        );
        await updateFolder(updatedFolder);
      }
    }
    
    // Supprimer l'entrée du document
    documents.removeWhere((document) => document.id == id);
    await _saveDocuments(documents);
  }

  @override
  Future<File?> getDocumentFile(String id) async {
    final document = await getDocumentById(id);
    if (document != null) {
      final file = File(document.path);
      if (await file.exists()) {
        return file;
      }
    }
    return null;
  }

  @override
  Future<String?> generateThumbnail(File file, DocumentType type) async {
    // Cette implémentation est simplifiée
    // Une vraie implémentation utiliserait un package comme flutter_image_compress pour les images
    // ou pdf_render pour les PDF
    
    // Pour l'instant, on ne génère des miniatures que pour les images
    if (type == DocumentType.image) {
      // Pour une vraie application, nous générerions une version compressée de l'image
      // Ici, nous utilisons simplement le même chemin comme placeholder
      return file.path;
    }
    
    return null;
  }

  Future<void> _saveDocuments(List<Document> documents) async {
    final documentsJson = documents
        .map((document) => jsonEncode(document.toJson()))
        .toList();
    
    await sharedPreferences.setStringList(_documentsKey, documentsJson);
  }

  // Gestion des dossiers
  
  @override
  Future<List<DocumentFolder>> getFolders() async {
    final foldersJson = sharedPreferences.getStringList(_foldersKey) ?? [];
    return foldersJson
        .map((json) => DocumentFolder.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<DocumentFolder?> getFolderById(String id) async {
    final folders = await getFolders();
    try {
      return folders.firstWhere((folder) => folder.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<DocumentFolder> createFolder(String name, {String? parentId}) async {
    final folder = DocumentFolder.create(
      name: name,
      parentId: parentId,
    );
    
    final folders = await getFolders();
    
    // Si ce dossier a un parent, mettre à jour le parent
    if (parentId != null) {
      final parentIndex = folders.indexWhere((f) => f.id == parentId);
      if (parentIndex != -1) {
        final parent = folders[parentIndex];
        final updatedParent = parent.copyWith(
          subfolderIds: [...parent.subfolderIds, folder.id],
          modifiedAt: DateTime.now(),
        );
        folders[parentIndex] = updatedParent;
      }
    }
    
    folders.add(folder);
    await _saveFolders(folders);
    
    return folder;
  }

  @override
  Future<void> updateFolder(DocumentFolder folder) async {
    final folders = await getFolders();
    final index = folders.indexWhere((f) => f.id == folder.id);
    
    if (index != -1) {
      // Mettre à jour le dossier avec la date de modification
      final updatedFolder = folder.copyWith(
        modifiedAt: DateTime.now(),
      );
      
      folders[index] = updatedFolder;
      await _saveFolders(folders);
    } else {
      throw Exception('Folder not found');
    }
  }

  @override
  Future<void> deleteFolder(String id) async {
    final folders = await getFolders();
    final folderToDelete = folders.firstWhere(
      (folder) => folder.id == id,
      orElse: () => throw Exception('Folder not found'),
    );
    
    // Vérifier s'il y a des sous-dossiers
    if (folderToDelete.subfolderIds.isNotEmpty) {
      throw Exception('Cannot delete folder with subfolders');
    }
    
    // Vérifier s'il y a des documents
    if (folderToDelete.documentIds.isNotEmpty) {
      throw Exception('Cannot delete folder with documents');
    }
    
    // Si ce dossier a un parent, mettre à jour le parent
    if (folderToDelete.parentId != null) {
      final parentIndex = folders.indexWhere((f) => f.id == folderToDelete.parentId);
      if (parentIndex != -1) {
        final parent = folders[parentIndex];
        final updatedParent = parent.copyWith(
          subfolderIds: List.from(parent.subfolderIds)..remove(id),
          modifiedAt: DateTime.now(),
        );
        folders[parentIndex] = updatedParent;
      }
    }
    
    // Supprimer le dossier
    folders.removeWhere((folder) => folder.id == id);
    await _saveFolders(folders);
  }

  Future<void> _saveFolders(List<DocumentFolder> folders) async {
    final foldersJson = folders
        .map((folder) => jsonEncode(folder.toJson()))
        .toList();
    
    await sharedPreferences.setStringList(_foldersKey, foldersJson);
  }

  Future<Directory> _getDocumentsDirectory() async {
    // Obtenir le répertoire de l'application
    final appDir = await getApplicationDocumentsDirectory();
    final documentsDir = Directory('${appDir.path}/documents');
    
    // Créer le répertoire s'il n'existe pas
    if (!await documentsDir.exists()) {
      await documentsDir.create(recursive: true);
    }
    
    return documentsDir;
  }
}
