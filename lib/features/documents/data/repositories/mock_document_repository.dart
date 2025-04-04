import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_template.dart';
import 'package:gbc_coachia/features/documents/domain/repositories/document_repository.dart';

/// Implémentation simulée du repository de documents
class MockDocumentRepository implements DocumentRepository {
  // Données simulées
  final List<Document> _documents = [];
  final List<DocumentTemplate> _templates = [];
  
  // Constructeur
  MockDocumentRepository() {
    _initMockData();
  }
  
  // Initialisation des données simulées
  void _initMockData() {
    // Modèles de documents
    final invoiceTemplate = DocumentTemplate(
      id: 'template1',
      name: 'Facture standard',
      description: 'Modèle de facture standard pour les clients',
      type: DocumentType.invoice,
      sections: [
        TemplateSection(
          id: 'section1',
          title: 'Informations client',
          description: 'Informations de base sur le client',
          fields: [
            TemplateField(
              id: 'clientName',
              label: 'Nom du client',
              type: FieldType.text,
              placeholder: 'Ex: Entreprise XYZ',
              required: true,
            ),
            TemplateField(
              id: 'clientEmail',
              label: 'Email du client',
              type: FieldType.email,
              placeholder: 'Ex: contact@xyz.com',
              required: true,
            ),
            TemplateField(
              id: 'clientAddress',
              label: 'Adresse du client',
              type: FieldType.address,
              placeholder: 'Ex: 123 Rue Principale, Ville',
              required: true,
            ),
          ],
        ),
        TemplateSection(
          id: 'section2',
          title: 'Détails de la facture',
          description: 'Informations sur les produits/services facturés',
          fields: [
            TemplateField(
              id: 'invoiceNumber',
              label: 'Numéro de facture',
              type: FieldType.text,
              required: true,
            ),
            TemplateField(
              id: 'invoiceDate',
              label: 'Date de facturation',
              type: FieldType.date,
              required: true,
              defaultValue: DateTime.now().toIso8601String(),
            ),
            TemplateField(
              id: 'dueDate',
              label: 'Date d\'échéance',
              type: FieldType.date,
              required: true,
              defaultValue: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
            ),
            TemplateField(
              id: 'amount',
              label: 'Montant total',
              type: FieldType.currency,
              required: true,
            ),
            TemplateField(
              id: 'currency',
              label: 'Devise',
              type: FieldType.dropdown,
              required: true,
              options: ['EUR', 'USD', 'GBP', 'CAD'],
              defaultValue: 'EUR',
            ),
            TemplateField(
              id: 'paymentTerms',
              label: 'Conditions de paiement',
              type: FieldType.textarea,
              placeholder: 'Ex: Paiement à 30 jours',
              required: false,
            ),
          ],
        ),
      ],
      content: 'Contenu du modèle de facture avec des placeholders pour les variables',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      isDefault: true,
    );
    
    final contractTemplate = DocumentTemplate(
      id: 'template2',
      name: 'Contrat de prestation',
      description: 'Modèle de contrat pour les prestations de service',
      type: DocumentType.contract,
      sections: [
        TemplateSection(
          id: 'section1',
          title: 'Parties concernées',
          description: 'Informations sur les parties du contrat',
          fields: [
            TemplateField(
              id: 'clientName',
              label: 'Nom du client',
              type: FieldType.text,
              required: true,
            ),
            TemplateField(
              id: 'clientEmail',
              label: 'Email du client',
              type: FieldType.email,
              required: true,
            ),
            TemplateField(
              id: 'clientAddress',
              label: 'Adresse du client',
              type: FieldType.address,
              required: true,
            ),
          ],
        ),
        TemplateSection(
          id: 'section2',
          title: 'Détails du contrat',
          description: 'Termes et conditions du contrat',
          fields: [
            TemplateField(
              id: 'contractTitle',
              label: 'Titre du contrat',
              type: FieldType.text,
              required: true,
            ),
            TemplateField(
              id: 'startDate',
              label: 'Date de début',
              type: FieldType.date,
              required: true,
              defaultValue: DateTime.now().toIso8601String(),
            ),
            TemplateField(
              id: 'endDate',
              label: 'Date de fin',
              type: FieldType.date,
              required: false,
            ),
            TemplateField(
              id: 'amount',
              label: 'Montant',
              type: FieldType.currency,
              required: true,
            ),
            TemplateField(
              id: 'currency',
              label: 'Devise',
              type: FieldType.dropdown,
              required: true,
              options: ['EUR', 'USD', 'GBP', 'CAD'],
              defaultValue: 'EUR',
            ),
            TemplateField(
              id: 'terms',
              label: 'Conditions générales',
              type: FieldType.textarea,
              required: true,
            ),
          ],
        ),
      ],
      content: 'Contenu du modèle de contrat avec des placeholders pour les variables',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      isDefault: true,
    );
    
    final proposalTemplate = DocumentTemplate(
      id: 'template3',
      name: 'Proposition commerciale',
      description: 'Modèle de proposition commerciale pour les prospects',
      type: DocumentType.proposal,
      sections: [
        TemplateSection(
          id: 'section1',
          title: 'Client potentiel',
          description: 'Informations sur le prospect',
          fields: [
            TemplateField(
              id: 'clientName',
              label: 'Nom du prospect',
              type: FieldType.text,
              required: true,
            ),
            TemplateField(
              id: 'clientEmail',
              label: 'Email du prospect',
              type: FieldType.email,
              required: true,
            ),
          ],
        ),
        TemplateSection(
          id: 'section2',
          title: 'Détails de l\'offre',
          description: 'Informations sur l\'offre proposée',
          fields: [
            TemplateField(
              id: 'proposalTitle',
              label: 'Titre de la proposition',
              type: FieldType.text,
              required: true,
            ),
            TemplateField(
              id: 'proposalDate',
              label: 'Date de la proposition',
              type: FieldType.date,
              required: true,
              defaultValue: DateTime.now().toIso8601String(),
            ),
            TemplateField(
              id: 'validUntil',
              label: 'Valable jusqu\'au',
              type: FieldType.date,
              required: true,
              defaultValue: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
            ),
            TemplateField(
              id: 'amount',
              label: 'Montant proposé',
              type: FieldType.currency,
              required: true,
            ),
            TemplateField(
              id: 'currency',
              label: 'Devise',
              type: FieldType.dropdown,
              required: true,
              options: ['EUR', 'USD', 'GBP', 'CAD'],
              defaultValue: 'EUR',
            ),
            TemplateField(
              id: 'description',
              label: 'Description de l\'offre',
              type: FieldType.textarea,
              required: true,
            ),
          ],
        ),
      ],
      content: 'Contenu du modèle de proposition avec des placeholders pour les variables',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      isDefault: true,
    );
    
    final reportTemplate = DocumentTemplate(
      id: 'template4',
      name: 'Rapport d\'activité',
      description: 'Modèle de rapport d\'activité mensuel',
      type: DocumentType.report,
      sections: [
        TemplateSection(
          id: 'section1',
          title: 'Informations générales',
          description: 'Informations de base sur le rapport',
          fields: [
            TemplateField(
              id: 'reportTitle',
              label: 'Titre du rapport',
              type: FieldType.text,
              required: true,
            ),
            TemplateField(
              id: 'reportPeriod',
              label: 'Période du rapport',
              type: FieldType.text,
              required: true,
              placeholder: 'Ex: Janvier 2024',
            ),
            TemplateField(
              id: 'author',
              label: 'Auteur',
              type: FieldType.text,
              required: true,
            ),
          ],
        ),
        TemplateSection(
          id: 'section2',
          title: 'Contenu du rapport',
          description: 'Corps du rapport',
          fields: [
            TemplateField(
              id: 'summary',
              label: 'Résumé',
              type: FieldType.textarea,
              required: true,
            ),
            TemplateField(
              id: 'achievements',
              label: 'Réalisations',
              type: FieldType.textarea,
              required: true,
            ),
            TemplateField(
              id: 'challenges',
              label: 'Défis rencontrés',
              type: FieldType.textarea,
              required: false,
            ),
            TemplateField(
              id: 'nextSteps',
              label: 'Prochaines étapes',
              type: FieldType.textarea,
              required: true,
            ),
          ],
        ),
      ],
      content: 'Contenu du modèle de rapport avec des placeholders pour les variables',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      isDefault: true,
    );
    
    // Ajouter les modèles à la liste
    _templates.addAll([
      invoiceTemplate,
      contractTemplate,
      proposalTemplate,
      reportTemplate,
    ]);
    
    // Documents
    _documents.addAll([
      Document(
        id: 'doc1',
        title: 'Facture #2024-001 - Client A',
        type: DocumentType.invoice,
        status: DocumentStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        templateId: 'template1',
        data: {
          'clientName': 'Client A',
          'clientEmail': 'clienta@example.com',
          'clientAddress': '123 Rue du Commerce, 75001 Paris',
          'invoiceNumber': '2024-001',
          'invoiceDate': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
          'dueDate': DateTime.now().add(const Duration(days: 15)).toIso8601String(),
          'amount': 1500.0,
          'currency': 'EUR',
          'paymentTerms': 'Paiement à 30 jours',
        },
        content: 'Contenu de la facture générée',
        clientName: 'Client A',
        clientEmail: 'clienta@example.com',
        amount: 1500.0,
        currency: 'EUR',
      ),
      
      Document(
        id: 'doc2',
        title: 'Contrat de prestation - Client B',
        type: DocumentType.contract,
        status: DocumentStatus.signed,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 25)),
        templateId: 'template2',
        data: {
          'clientName': 'Client B',
          'clientEmail': 'clientb@example.com',
          'clientAddress': '456 Avenue des Affaires, 69002 Lyon',
          'contractTitle': 'Développement de site web',
          'startDate': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
          'endDate': DateTime.now().add(const Duration(days: 60)).toIso8601String(),
          'amount': 5000.0,
          'currency': 'EUR',
          'terms': 'Le prestataire s\'engage à livrer le site web dans les délais convenus...',
        },
        content: 'Contenu du contrat généré',
        clientName: 'Client B',
        clientEmail: 'clientb@example.com',
        amount: 5000.0,
        currency: 'EUR',
        expiresAt: DateTime.now().add(const Duration(days: 60)),
      ),
      
      Document(
        id: 'doc3',
        title: 'Proposition commerciale - Prospect C',
        type: DocumentType.proposal,
        status: DocumentStatus.draft,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        templateId: 'template3',
        data: {
          'clientName': 'Prospect C',
          'clientEmail': 'prospectc@example.com',
          'proposalTitle': 'Services de conseil en marketing',
          'proposalDate': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
          'validUntil': DateTime.now().add(const Duration(days: 23)).toIso8601String(),
          'amount': 2500.0,
          'currency': 'EUR',
          'description': 'Cette proposition comprend une analyse complète de votre stratégie marketing...',
        },
        content: 'Contenu de la proposition généré',
        clientName: 'Prospect C',
        clientEmail: 'prospectc@example.com',
        amount: 2500.0,
        currency: 'EUR',
        expiresAt: DateTime.now().add(const Duration(days: 23)),
      ),
      
      Document(
        id: 'doc4',
        title: 'Rapport d\'activité - Janvier 2024',
        type: DocumentType.report,
        status: DocumentStatus.archived,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 58)),
        templateId: 'template4',
        data: {
          'reportTitle': 'Rapport d\'activité mensuel',
          'reportPeriod': 'Janvier 2024',
          'author': 'John Doe',
          'summary': 'Ce rapport présente les activités réalisées au cours du mois de janvier 2024...',
          'achievements': 'Lancement de la nouvelle campagne marketing, Acquisition de 3 nouveaux clients...',
          'challenges': 'Retards dans le développement du projet X...',
          'nextSteps': 'Finaliser le projet X, Démarrer la phase 2 du projet Y...',
        },
        content: 'Contenu du rapport généré',
        tags: ['rapport', 'mensuel', 'activité'],
      ),
      
      Document(
        id: 'doc5',
        title: 'Facture #2024-002 - Client B',
        type: DocumentType.invoice,
        status: DocumentStatus.paid,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
        templateId: 'template1',
        data: {
          'clientName': 'Client B',
          'clientEmail': 'clientb@example.com',
          'clientAddress': '456 Avenue des Affaires, 69002 Lyon',
          'invoiceNumber': '2024-002',
          'invoiceDate': DateTime.now().subtract(const Duration(days: 45)).toIso8601String(),
          'dueDate': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
          'amount': 3000.0,
          'currency': 'EUR',
          'paymentTerms': 'Paiement à 30 jours',
        },
        content: 'Contenu de la facture générée',
        clientName: 'Client B',
        clientEmail: 'clientb@example.com',
        amount: 3000.0,
        currency: 'EUR',
      ),
    ]);
  }
  
  @override
  Future<List<Document>> getDocuments() async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Renvoyer une copie de la liste des documents (triés par date de création)
    final documents = List<Document>.from(_documents);
    documents.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return documents;
  }
  
  @override
  Future<Document> getDocumentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final document = _documents.firstWhere(
      (doc) => doc.id == id,
      orElse: () => throw Exception('Document non trouvé avec ID: $id'),
    );
    
    return document;
  }
  
  @override
  Future<Document> createDocument(Document document) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Ajouter le document à la liste
    _documents.add(document);
    
    return document;
  }
  
  @override
  Future<Document> updateDocument(Document document) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Trouver l'index du document existant
    final index = _documents.indexWhere((doc) => doc.id == document.id);
    if (index == -1) {
      throw Exception('Document non trouvé avec ID: ${document.id}');
    }
    
    // Mettre à jour le document
    _documents[index] = document.copyWith(
      updatedAt: DateTime.now(),
    );
    
    return _documents[index];
  }
  
  @override
  Future<void> deleteDocument(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Vérifier si le document existe
    final index = _documents.indexWhere((doc) => doc.id == id);
    if (index == -1) {
      throw Exception('Document non trouvé avec ID: $id');
    }
    
    // Supprimer le document
    _documents.removeAt(index);
  }
  
  @override
  Future<Document> changeDocumentStatus(String id, DocumentStatus status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Trouver le document
    final index = _documents.indexWhere((doc) => doc.id == id);
    if (index == -1) {
      throw Exception('Document non trouvé avec ID: $id');
    }
    
    // Mettre à jour le statut
    final updatedDocument = _documents[index].copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    
    // Mettre à jour le document dans la liste
    _documents[index] = updatedDocument;
    
    return updatedDocument;
  }
  
  @override
  Future<List<DocumentTemplate>> getTemplates() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Renvoyer une copie de la liste des modèles
    return List<DocumentTemplate>.from(_templates);
  }
  
  @override
  Future<DocumentTemplate> getTemplateById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final template = _templates.firstWhere(
      (template) => template.id == id,
      orElse: () => throw Exception('Modèle non trouvé avec ID: $id'),
    );
    
    return template;
  }
  
  @override
  Future<DocumentTemplate> createTemplate(DocumentTemplate template) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Ajouter le modèle à la liste
    _templates.add(template);
    
    return template;
  }
  
  @override
  Future<DocumentTemplate> updateTemplate(DocumentTemplate template) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Trouver l'index du modèle existant
    final index = _templates.indexWhere((t) => t.id == template.id);
    if (index == -1) {
      throw Exception('Modèle non trouvé avec ID: ${template.id}');
    }
    
    // Mettre à jour le modèle
    _templates[index] = template.copyWith(
      updatedAt: DateTime.now(),
    );
    
    return _templates[index];
  }
  
  @override
  Future<void> deleteTemplate(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Vérifier si le modèle existe
    final index = _templates.indexWhere((template) => template.id == id);
    if (index == -1) {
      throw Exception('Modèle non trouvé avec ID: $id');
    }
    
    // Supprimer le modèle
    _templates.removeAt(index);
  }
  
  @override
  Future<Document> generateDocumentFromTemplate({
    required String templateId,
    required Map<String, dynamic> data,
    required String title,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Trouver le modèle
    final template = await getTemplateById(templateId);
    
    // Créer un nouveau document
    final newDocument = Document(
      id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      type: template.type,
      status: DocumentStatus.draft, // Par défaut, le document est un brouillon
      createdAt: DateTime.now(),
      templateId: templateId,
      data: data,
      content: _processTemplateContent(template.content, data),
      clientName: data['clientName'] as String?,
      clientEmail: data['clientEmail'] as String?,
      amount: data['amount'] is double ? data['amount'] as double : null,
      currency: data['currency'] as String?,
      expiresAt: data['expiresAt'] != null ? DateTime.parse(data['expiresAt'] as String) : null,
    );
    
    // Ajouter le document à la liste
    _documents.add(newDocument);
    
    return newDocument;
  }
  
  @override
  Future<List<Document>> filterDocumentsByType(DocumentType type) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Filtrer les documents par type
    final filteredDocuments = _documents.where((doc) => doc.type == type).toList();
    
    // Trier par date de création (plus récent d'abord)
    filteredDocuments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return filteredDocuments;
  }
  
  @override
  Future<List<Document>> filterDocumentsByStatus(DocumentStatus status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Filtrer les documents par statut
    final filteredDocuments = _documents.where((doc) => doc.status == status).toList();
    
    // Trier par date de création (plus récent d'abord)
    filteredDocuments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return filteredDocuments;
  }
  
  @override
  Future<List<DocumentTemplate>> filterTemplatesByType(DocumentType type) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Filtrer les modèles par type
    return _templates.where((template) => template.type == type).toList();
  }
  
  // Méthode utilitaire pour remplacer les variables dans le contenu du modèle
  String _processTemplateContent(String templateContent, Map<String, dynamic> data) {
    String processedContent = templateContent;
    
    // Remplacer les variables par les valeurs
    data.forEach((key, value) {
      if (value != null) {
        processedContent = processedContent.replaceAll('{{$key}}', value.toString());
      }
    });
    
    return processedContent;
  }
}
