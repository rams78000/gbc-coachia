import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_template.dart';

/// Interface pour le repository de documents
abstract class DocumentRepository {
  /// Récupère tous les documents
  Future<List<Document>> getAllDocuments();
  
  /// Récupère un document par son ID
  Future<Document?> getDocumentById(String id);
  
  /// Récupère les documents par type
  Future<List<Document>> getDocumentsByType(DocumentType type);
  
  /// Récupère les documents par statut
  Future<List<Document>> getDocumentsByStatus(DocumentStatus status);
  
  /// Recherche de documents par mots-clés
  Future<List<Document>> searchDocuments(String query);
  
  /// Ajoute un nouveau document
  Future<Document> addDocument(Document document);
  
  /// Met à jour un document existant
  Future<Document> updateDocument(Document document);
  
  /// Supprime un document
  Future<bool> deleteDocument(String id);
  
  /// Change le statut d'un document
  Future<Document> changeDocumentStatus(String id, DocumentStatus newStatus);
  
  /// Récupère tous les modèles de documents
  Future<List<DocumentTemplate>> getAllTemplates();
  
  /// Récupère un modèle de document par son ID
  Future<DocumentTemplate?> getTemplateById(String id);
  
  /// Récupère les modèles de documents par type
  Future<List<DocumentTemplate>> getTemplatesByType(DocumentType type);
  
  /// Ajoute un nouveau modèle de document
  Future<DocumentTemplate> addTemplate(DocumentTemplate template);
  
  /// Met à jour un modèle de document existant
  Future<DocumentTemplate> updateTemplate(DocumentTemplate template);
  
  /// Supprime un modèle de document
  Future<bool> deleteTemplate(String id);
  
  /// Génère un document à partir d'un modèle et de données
  Future<Document> generateDocumentFromTemplate({
    required String templateId,
    required Map<String, dynamic> data, 
    required String title,
  });
}
