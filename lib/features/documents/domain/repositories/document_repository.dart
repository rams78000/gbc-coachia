import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_template.dart';

/// Contrat pour le repository de documents
abstract class DocumentRepository {
  /// Obtient la liste des documents
  Future<List<Document>> getDocuments();
  
  /// Obtient un document par son ID
  Future<Document> getDocumentById(String id);
  
  /// Crée un nouveau document
  Future<Document> createDocument(Document document);
  
  /// Met à jour un document existant
  Future<Document> updateDocument(Document document);
  
  /// Supprime un document
  Future<void> deleteDocument(String id);
  
  /// Change le statut d'un document
  Future<Document> changeDocumentStatus(String id, DocumentStatus status);
  
  /// Obtient la liste des modèles de documents
  Future<List<DocumentTemplate>> getTemplates();
  
  /// Obtient un modèle de document par son ID
  Future<DocumentTemplate> getTemplateById(String id);
  
  /// Crée un nouveau modèle de document
  Future<DocumentTemplate> createTemplate(DocumentTemplate template);
  
  /// Met à jour un modèle de document existant
  Future<DocumentTemplate> updateTemplate(DocumentTemplate template);
  
  /// Supprime un modèle de document
  Future<void> deleteTemplate(String id);
  
  /// Génère un document à partir d'un modèle
  Future<Document> generateDocumentFromTemplate({
    required String templateId,
    required Map<String, dynamic> data,
    required String title,
  });
  
  /// Filtre les documents par type
  Future<List<Document>> filterDocumentsByType(DocumentType type);
  
  /// Filtre les documents par statut
  Future<List<Document>> filterDocumentsByStatus(DocumentStatus status);
  
  /// Filtre les modèles par type
  Future<List<DocumentTemplate>> filterTemplatesByType(DocumentType type);
}
