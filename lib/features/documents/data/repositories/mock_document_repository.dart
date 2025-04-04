import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_template.dart';
import 'package:gbc_coachia/features/documents/domain/repositories/document_repository.dart';
import 'package:uuid/uuid.dart';

/// Implémentation mock du repository pour les documents
class MockDocumentRepository implements DocumentRepository {
  // Liste de documents pour la simulation
  final List<Document> _documents = [];
  
  // Liste de modèles de documents pour la simulation
  final List<DocumentTemplate> _templates = [];
  
  // Générateur d'ID
  final _uuid = const Uuid();
  
  // Constructeur
  MockDocumentRepository() {
    // Initialiser avec des données de test
    _initMockData();
  }
  
  // Initialise des données de test
  void _initMockData() {
    // Créer quelques modèles de documents
    _templates.addAll([
      DocumentTemplate(
        id: '1',
        name: 'Facture Standard',
        description: 'Modèle de facture standard pour les prestations de service',
        type: DocumentType.invoice,
        thumbnailUrl: 'assets/images/templates/invoice.jpg',
        templateContent: '''
        <h1>FACTURE</h1>
        <p>Date: {{date}}</p>
        <p>Numéro de facture: {{invoiceNumber}}</p>
        <p>Client: {{clientName}}</p>
        
        <table>
          <tr>
            <th>Description</th>
            <th>Quantité</th>
            <th>Prix unitaire</th>
            <th>Total</th>
          </tr>
          <tr>
            <td>{{description}}</td>
            <td>{{quantity}}</td>
            <td>{{unitPrice}} €</td>
            <td>{{total}} €</td>
          </tr>
        </table>
        
        <p>Total HT: {{totalBeforeTax}} €</p>
        <p>TVA ({{taxRate}}%): {{taxAmount}} €</p>
        <p>Total TTC: {{totalAfterTax}} €</p>
        
        <p>Conditions de paiement: {{paymentTerms}}</p>
        <p>Coordonnées bancaires: {{bankDetails}}</p>
        ''',
        fields: [
          DocumentField(
            id: 'date',
            label: 'Date de facturation',
            placeholder: 'JJ/MM/AAAA',
            required: true,
            type: DocumentFieldType.date,
          ),
          DocumentField(
            id: 'invoiceNumber',
            label: 'Numéro de facture',
            placeholder: 'FAC-001',
            required: true,
            type: DocumentFieldType.text,
          ),
          DocumentField(
            id: 'clientName',
            label: 'Nom du client',
            placeholder: 'Entreprise XYZ',
            required: true,
            type: DocumentFieldType.text,
          ),
          DocumentField(
            id: 'description',
            label: 'Description de la prestation',
            placeholder: 'Développement de site web',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'quantity',
            label: 'Quantité',
            placeholder: '1',
            required: true,
            type: DocumentFieldType.number,
          ),
          DocumentField(
            id: 'unitPrice',
            label: 'Prix unitaire (€)',
            placeholder: '1000',
            required: true,
            type: DocumentFieldType.currency,
          ),
          DocumentField(
            id: 'total',
            label: 'Total (€)',
            placeholder: '1000',
            required: true,
            type: DocumentFieldType.currency,
          ),
          DocumentField(
            id: 'totalBeforeTax',
            label: 'Total HT (€)',
            placeholder: '1000',
            required: true,
            type: DocumentFieldType.currency,
          ),
          DocumentField(
            id: 'taxRate',
            label: 'Taux de TVA (%)',
            placeholder: '20',
            required: true,
            type: DocumentFieldType.number,
          ),
          DocumentField(
            id: 'taxAmount',
            label: 'Montant de TVA (€)',
            placeholder: '200',
            required: true,
            type: DocumentFieldType.currency,
          ),
          DocumentField(
            id: 'totalAfterTax',
            label: 'Total TTC (€)',
            placeholder: '1200',
            required: true,
            type: DocumentFieldType.currency,
          ),
          DocumentField(
            id: 'paymentTerms',
            label: 'Conditions de paiement',
            placeholder: '30 jours',
            required: true,
            type: DocumentFieldType.text,
          ),
          DocumentField(
            id: 'bankDetails',
            label: 'Coordonnées bancaires',
            placeholder: 'IBAN: FR76...',
            required: true,
            type: DocumentFieldType.multiline,
          ),
        ],
        isDefault: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      DocumentTemplate(
        id: '2',
        name: 'Proposition commerciale',
        description: 'Modèle de proposition commerciale pour présenter vos services',
        type: DocumentType.proposal,
        thumbnailUrl: 'assets/images/templates/proposal.jpg',
        templateContent: '''
        <h1>PROPOSITION COMMERCIALE</h1>
        <p>Date: {{date}}</p>
        <p>Référence: {{reference}}</p>
        <p>Client: {{clientName}}</p>
        
        <h2>Contexte</h2>
        <p>{{context}}</p>
        
        <h2>Solution proposée</h2>
        <p>{{solution}}</p>
        
        <h2>Méthodologie</h2>
        <p>{{methodology}}</p>
        
        <h2>Planning</h2>
        <p>{{schedule}}</p>
        
        <h2>Budget</h2>
        <p>{{budget}}</p>
        
        <h2>Conditions</h2>
        <p>{{conditions}}</p>
        ''',
        fields: [
          DocumentField(
            id: 'date',
            label: 'Date',
            placeholder: 'JJ/MM/AAAA',
            required: true,
            type: DocumentFieldType.date,
          ),
          DocumentField(
            id: 'reference',
            label: 'Référence',
            placeholder: 'PROP-001',
            required: true,
            type: DocumentFieldType.text,
          ),
          DocumentField(
            id: 'clientName',
            label: 'Nom du client',
            placeholder: 'Entreprise XYZ',
            required: true,
            type: DocumentFieldType.text,
          ),
          DocumentField(
            id: 'context',
            label: 'Contexte',
            placeholder: 'Description du contexte...',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'solution',
            label: 'Solution proposée',
            placeholder: 'Description de la solution...',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'methodology',
            label: 'Méthodologie',
            placeholder: 'Description de la méthodologie...',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'schedule',
            label: 'Planning',
            placeholder: 'Description du planning...',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'budget',
            label: 'Budget',
            placeholder: 'Description du budget...',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'conditions',
            label: 'Conditions',
            placeholder: 'Description des conditions...',
            required: true,
            type: DocumentFieldType.multiline,
          ),
        ],
        isDefault: false,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      DocumentTemplate(
        id: '3',
        name: 'Contrat de prestation',
        description: 'Modèle de contrat de prestation de services',
        type: DocumentType.contract,
        thumbnailUrl: 'assets/images/templates/contract.jpg',
        templateContent: '''
        <h1>CONTRAT DE PRESTATION DE SERVICES</h1>
        <p>Entre les soussignés :</p>
        <p>{{providerName}}, {{providerStatus}}, {{providerAddress}}</p>
        <p>Ci-après dénommé "le Prestataire",</p>
        <p>Et</p>
        <p>{{clientName}}, {{clientStatus}}, {{clientAddress}}</p>
        <p>Ci-après dénommé "le Client",</p>
        
        <h2>Article 1 - Objet du contrat</h2>
        <p>{{contractObject}}</p>
        
        <h2>Article 2 - Durée</h2>
        <p>{{contractDuration}}</p>
        
        <h2>Article 3 - Obligations du Prestataire</h2>
        <p>{{providerObligations}}</p>
        
        <h2>Article 4 - Obligations du Client</h2>
        <p>{{clientObligations}}</p>
        
        <h2>Article 5 - Conditions financières</h2>
        <p>{{financialConditions}}</p>
        
        <h2>Article 6 - Confidentialité</h2>
        <p>{{confidentiality}}</p>
        
        <h2>Article 7 - Résiliation</h2>
        <p>{{termination}}</p>
        
        <h2>Article 8 - Loi applicable et juridiction</h2>
        <p>{{applicableLaw}}</p>
        
        <p>Fait à {{location}}, le {{date}}</p>
        <p>Pour le Prestataire : {{providerSignature}}</p>
        <p>Pour le Client : {{clientSignature}}</p>
        ''',
        fields: [
          DocumentField(
            id: 'providerName',
            label: 'Nom du Prestataire',
            placeholder: 'Votre nom ou raison sociale',
            required: true,
            type: DocumentFieldType.text,
          ),
          DocumentField(
            id: 'providerStatus',
            label: 'Statut du Prestataire',
            placeholder: 'Freelance, SARL, etc.',
            required: true,
            type: DocumentFieldType.text,
          ),
          DocumentField(
            id: 'providerAddress',
            label: 'Adresse du Prestataire',
            placeholder: 'Votre adresse complète',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'clientName',
            label: 'Nom du Client',
            placeholder: 'Nom ou raison sociale du client',
            required: true,
            type: DocumentFieldType.text,
          ),
          DocumentField(
            id: 'clientStatus',
            label: 'Statut du Client',
            placeholder: 'SARL, SA, etc.',
            required: true,
            type: DocumentFieldType.text,
          ),
          DocumentField(
            id: 'clientAddress',
            label: 'Adresse du Client',
            placeholder: 'Adresse complète du client',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'contractObject',
            label: 'Objet du contrat',
            placeholder: 'Description des services fournis',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'contractDuration',
            label: 'Durée du contrat',
            placeholder: 'Ex: Ce contrat est conclu pour une durée de 6 mois à compter de sa signature.',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'providerObligations',
            label: 'Obligations du Prestataire',
            placeholder: 'Détail des obligations du prestataire',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'clientObligations',
            label: 'Obligations du Client',
            placeholder: 'Détail des obligations du client',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'financialConditions',
            label: 'Conditions financières',
            placeholder: 'Tarifs, modalités de paiement, etc.',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'confidentiality',
            label: 'Clause de confidentialité',
            placeholder: 'Détail de la clause de confidentialité',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'termination',
            label: 'Clause de résiliation',
            placeholder: 'Détail de la clause de résiliation',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'applicableLaw',
            label: 'Loi applicable',
            placeholder: 'Ex: Le présent contrat est soumis au droit français.',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'location',
            label: 'Lieu de signature',
            placeholder: 'Ex: Paris',
            required: true,
            type: DocumentFieldType.text,
          ),
          DocumentField(
            id: 'date',
            label: 'Date de signature',
            placeholder: 'JJ/MM/AAAA',
            required: true,
            type: DocumentFieldType.date,
          ),
          DocumentField(
            id: 'providerSignature',
            label: 'Signature du Prestataire',
            placeholder: 'Nom et signature',
            required: true,
            type: DocumentFieldType.text,
          ),
          DocumentField(
            id: 'clientSignature',
            label: 'Signature du Client',
            placeholder: 'Nom et signature',
            required: true,
            type: DocumentFieldType.text,
          ),
        ],
        isDefault: false,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      DocumentTemplate(
        id: '4',
        name: 'Rapport d\'activité',
        description: 'Modèle de rapport d\'activité mensuel',
        type: DocumentType.report,
        thumbnailUrl: 'assets/images/templates/report.jpg',
        templateContent: '''
        <h1>RAPPORT D'ACTIVITÉ</h1>
        <p>Période: {{period}}</p>
        <p>Préparé par: {{author}}</p>
        <p>Date: {{date}}</p>
        
        <h2>Résumé exécutif</h2>
        <p>{{executiveSummary}}</p>
        
        <h2>Activités réalisées</h2>
        <p>{{activities}}</p>
        
        <h2>Résultats obtenus</h2>
        <p>{{results}}</p>
        
        <h2>Défis rencontrés</h2>
        <p>{{challenges}}</p>
        
        <h2>Prochaines étapes</h2>
        <p>{{nextSteps}}</p>
        
        <h2>Budget et ressources</h2>
        <p>{{budget}}</p>
        
        <h2>Annexes</h2>
        <p>{{appendices}}</p>
        ''',
        fields: [
          DocumentField(
            id: 'period',
            label: 'Période du rapport',
            placeholder: 'Ex: Janvier 2023',
            required: true,
            type: DocumentFieldType.text,
          ),
          DocumentField(
            id: 'author',
            label: 'Auteur du rapport',
            placeholder: 'Votre nom',
            required: true,
            type: DocumentFieldType.text,
          ),
          DocumentField(
            id: 'date',
            label: 'Date du rapport',
            placeholder: 'JJ/MM/AAAA',
            required: true,
            type: DocumentFieldType.date,
          ),
          DocumentField(
            id: 'executiveSummary',
            label: 'Résumé exécutif',
            placeholder: 'Résumé des points clés du rapport',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'activities',
            label: 'Activités réalisées',
            placeholder: 'Liste des activités réalisées pendant la période',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'results',
            label: 'Résultats obtenus',
            placeholder: 'Description des résultats obtenus',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'challenges',
            label: 'Défis rencontrés',
            placeholder: 'Description des défis ou obstacles rencontrés',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'nextSteps',
            label: 'Prochaines étapes',
            placeholder: 'Plan d\'action pour la prochaine période',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'budget',
            label: 'Budget et ressources',
            placeholder: 'Détail de l\'utilisation du budget et des ressources',
            required: true,
            type: DocumentFieldType.multiline,
          ),
          DocumentField(
            id: 'appendices',
            label: 'Annexes',
            placeholder: 'Liste des documents annexes',
            required: false,
            type: DocumentFieldType.multiline,
          ),
        ],
        isDefault: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ]);
    
    // Créer quelques documents
    _documents.addAll([
      Document(
        id: '1',
        title: 'Facture - Client ABC - Mars 2023',
        type: DocumentType.invoice,
        status: DocumentStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 44)),
        content: '''
        <h1>FACTURE</h1>
        <p>Date: 15/03/2023</p>
        <p>Numéro de facture: FAC-2023-001</p>
        <p>Client: Entreprise ABC</p>
        
        <table>
          <tr>
            <th>Description</th>
            <th>Quantité</th>
            <th>Prix unitaire</th>
            <th>Total</th>
          </tr>
          <tr>
            <td>Développement application mobile</td>
            <td>1</td>
            <td>5000 €</td>
            <td>5000 €</td>
          </tr>
        </table>
        
        <p>Total HT: 5000 €</p>
        <p>TVA (20%): 1000 €</p>
        <p>Total TTC: 6000 €</p>
        
        <p>Conditions de paiement: 30 jours</p>
        <p>Coordonnées bancaires: IBAN FR76 1234 5678 9012 3456 7890 123</p>
        ''',
        data: {
          'date': '15/03/2023',
          'invoiceNumber': 'FAC-2023-001',
          'clientName': 'Entreprise ABC',
          'description': 'Développement application mobile',
          'quantity': '1',
          'unitPrice': '5000',
          'total': '5000',
          'totalBeforeTax': '5000',
          'taxRate': '20',
          'taxAmount': '1000',
          'totalAfterTax': '6000',
          'paymentTerms': '30 jours',
          'bankDetails': 'IBAN FR76 1234 5678 9012 3456 7890 123',
        },
        recipientEmail: 'contact@abc-company.com',
        recipientName: 'Entreprise ABC',
        previewUrl: 'assets/images/documents/invoice_preview.jpg',
      ),
      Document(
        id: '2',
        title: 'Proposition - Refonte site web XYZ',
        type: DocumentType.proposal,
        status: DocumentStatus.draft,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 14)),
        content: '''
        <h1>PROPOSITION COMMERCIALE</h1>
        <p>Date: 15/05/2023</p>
        <p>Référence: PROP-2023-002</p>
        <p>Client: Société XYZ</p>
        
        <h2>Contexte</h2>
        <p>La société XYZ souhaite refondre son site web pour améliorer sa présence en ligne et augmenter ses conversions.</p>
        
        <h2>Solution proposée</h2>
        <p>Nous proposons une refonte complète du site avec un design moderne, une optimisation pour les moteurs de recherche et une expérience utilisateur améliorée.</p>
        
        <h2>Méthodologie</h2>
        <p>Notre approche se fera en 4 phases : analyse, conception, développement et déploiement.</p>
        
        <h2>Planning</h2>
        <p>Le projet se déroulera sur 3 mois à partir de la validation de cette proposition.</p>
        
        <h2>Budget</h2>
        <p>Le budget total pour ce projet est de 8000 € HT.</p>
        
        <h2>Conditions</h2>
        <p>Paiement en 3 fois : 30% à la commande, 40% à mi-projet, 30% à la livraison.</p>
        ''',
        data: {
          'date': '15/05/2023',
          'reference': 'PROP-2023-002',
          'clientName': 'Société XYZ',
          'context': 'La société XYZ souhaite refondre son site web pour améliorer sa présence en ligne et augmenter ses conversions.',
          'solution': 'Nous proposons une refonte complète du site avec un design moderne, une optimisation pour les moteurs de recherche et une expérience utilisateur améliorée.',
          'methodology': 'Notre approche se fera en 4 phases : analyse, conception, développement et déploiement.',
          'schedule': 'Le projet se déroulera sur 3 mois à partir de la validation de cette proposition.',
          'budget': 'Le budget total pour ce projet est de 8000 € HT.',
          'conditions': 'Paiement en 3 fois : 30% à la commande, 40% à mi-projet, 30% à la livraison.',
        },
        previewUrl: 'assets/images/documents/proposal_preview.jpg',
      ),
      Document(
        id: '3',
        title: 'Contrat - Mission de conseil DEF',
        type: DocumentType.contract,
        status: DocumentStatus.signed,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
        expiryDate: DateTime.now().add(const Duration(days: 305)),
        content: '''
        <h1>CONTRAT DE PRESTATION DE SERVICES</h1>
        <p>Entre les soussignés :</p>
        <p>MonEntreprise, SARL, 123 rue des Entrepreneurs, 75001 Paris</p>
        <p>Ci-après dénommé "le Prestataire",</p>
        <p>Et</p>
        <p>Société DEF, SA, 456 avenue des Clients, 69002 Lyon</p>
        <p>Ci-après dénommé "le Client",</p>
        
        <h2>Article 1 - Objet du contrat</h2>
        <p>Le présent contrat a pour objet la réalisation d'une mission de conseil en stratégie digitale.</p>
        
        <h2>Article 2 - Durée</h2>
        <p>Ce contrat est conclu pour une durée de 12 mois à compter de sa signature.</p>
        
        <h2>Article 3 - Obligations du Prestataire</h2>
        <p>Le Prestataire s'engage à fournir un service de qualité et à respecter les délais convenus.</p>
        
        <h2>Article 4 - Obligations du Client</h2>
        <p>Le Client s'engage à fournir toutes les informations nécessaires à la bonne exécution de la mission.</p>
        
        <h2>Article 5 - Conditions financières</h2>
        <p>Les honoraires sont fixés à 1000 € HT par mois, payables à 30 jours fin de mois.</p>
        
        <h2>Article 6 - Confidentialité</h2>
        <p>Les parties s'engagent à respecter la confidentialité des informations échangées.</p>
        
        <h2>Article 7 - Résiliation</h2>
        <p>Le contrat peut être résilié avec un préavis de 2 mois par lettre recommandée.</p>
        
        <h2>Article 8 - Loi applicable et juridiction</h2>
        <p>Le présent contrat est soumis au droit français.</p>
        
        <p>Fait à Paris, le 01/02/2023</p>
        <p>Pour le Prestataire : Jean Dupont</p>
        <p>Pour le Client : Marie Martin</p>
        ''',
        data: {
          'providerName': 'MonEntreprise',
          'providerStatus': 'SARL',
          'providerAddress': '123 rue des Entrepreneurs, 75001 Paris',
          'clientName': 'Société DEF',
          'clientStatus': 'SA',
          'clientAddress': '456 avenue des Clients, 69002 Lyon',
          'contractObject': 'Le présent contrat a pour objet la réalisation d\'une mission de conseil en stratégie digitale.',
          'contractDuration': 'Ce contrat est conclu pour une durée de 12 mois à compter de sa signature.',
          'providerObligations': 'Le Prestataire s\'engage à fournir un service de qualité et à respecter les délais convenus.',
          'clientObligations': 'Le Client s\'engage à fournir toutes les informations nécessaires à la bonne exécution de la mission.',
          'financialConditions': 'Les honoraires sont fixés à 1000 € HT par mois, payables à 30 jours fin de mois.',
          'confidentiality': 'Les parties s\'engagent à respecter la confidentialité des informations échangées.',
          'termination': 'Le contrat peut être résilié avec un préavis de 2 mois par lettre recommandée.',
          'applicableLaw': 'Le présent contrat est soumis au droit français.',
          'location': 'Paris',
          'date': '01/02/2023',
          'providerSignature': 'Jean Dupont',
          'clientSignature': 'Marie Martin',
        },
        recipientEmail: 'contact@def-company.com',
        recipientName: 'Société DEF',
        previewUrl: 'assets/images/documents/contract_preview.jpg',
      ),
      Document(
        id: '4',
        title: 'Rapport - Analyse SEO Premier trimestre',
        type: DocumentType.report,
        status: DocumentStatus.archived,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now().subtract(const Duration(days: 89)),
        content: '''
        <h1>RAPPORT D'ACTIVITÉ</h1>
        <p>Période: Premier trimestre 2023</p>
        <p>Préparé par: Jean Dupont</p>
        <p>Date: 31/03/2023</p>
        
        <h2>Résumé exécutif</h2>
        <p>Ce rapport présente les résultats de l'analyse SEO réalisée au cours du premier trimestre 2023.</p>
        
        <h2>Activités réalisées</h2>
        <p>- Audit technique du site web<br>- Analyse des mots-clés<br>- Optimisation du contenu<br>- Création de backlinks</p>
        
        <h2>Résultats obtenus</h2>
        <p>- Augmentation du trafic organique de 25%<br>- Amélioration des positions dans les SERP<br>- Réduction des erreurs techniques</p>
        
        <h2>Défis rencontrés</h2>
        <p>- Forte concurrence sur les mots-clés principaux<br>- Problèmes techniques liés à la vitesse de chargement</p>
        
        <h2>Prochaines étapes</h2>
        <p>- Renforcer la stratégie de contenu<br>- Optimiser davantage la vitesse du site<br>- Développer de nouveaux partenariats pour les backlinks</p>
        
        <h2>Budget et ressources</h2>
        <p>Le budget alloué de 3000 € a été utilisé à 85%.</p>
        
        <h2>Annexes</h2>
        <p>- Rapport d'analyse détaillé<br>- Tableau des positions des mots-clés</p>
        ''',
        data: {
          'period': 'Premier trimestre 2023',
          'author': 'Jean Dupont',
          'date': '31/03/2023',
          'executiveSummary': 'Ce rapport présente les résultats de l\'analyse SEO réalisée au cours du premier trimestre 2023.',
          'activities': '- Audit technique du site web\n- Analyse des mots-clés\n- Optimisation du contenu\n- Création de backlinks',
          'results': '- Augmentation du trafic organique de 25%\n- Amélioration des positions dans les SERP\n- Réduction des erreurs techniques',
          'challenges': '- Forte concurrence sur les mots-clés principaux\n- Problèmes techniques liés à la vitesse de chargement',
          'nextSteps': '- Renforcer la stratégie de contenu\n- Optimiser davantage la vitesse du site\n- Développer de nouveaux partenariats pour les backlinks',
          'budget': 'Le budget alloué de 3000 € a été utilisé à 85%.',
          'appendices': '- Rapport d\'analyse détaillé\n- Tableau des positions des mots-clés',
        },
        previewUrl: 'assets/images/documents/report_preview.jpg',
      ),
    ]);
  }

  @override
  Future<List<Document>> getAllDocuments() async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));
    return [..._documents];
  }

  @override
  Future<Document?> getDocumentById(String id) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    return _documents.firstWhere((doc) => doc.id == id, orElse: () => throw Exception('Document not found'));
  }

  @override
  Future<List<Document>> getDocumentsByType(DocumentType type) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 400));
    return _documents.where((doc) => doc.type == type).toList();
  }

  @override
  Future<List<Document>> getDocumentsByStatus(DocumentStatus status) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 400));
    return _documents.where((doc) => doc.status == status).toList();
  }

  @override
  Future<List<Document>> searchDocuments(String query) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 600));
    
    final queryLower = query.toLowerCase();
    return _documents.where((doc) => 
      doc.title.toLowerCase().contains(queryLower) || 
      doc.content.toLowerCase().contains(queryLower) ||
      (doc.recipientName?.toLowerCase().contains(queryLower) ?? false)
    ).toList();
  }

  @override
  Future<Document> addDocument(Document document) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 700));
    
    final newDoc = document.id.isEmpty 
        ? document.copyWith(id: _uuid.v4())
        : document;
    
    _documents.add(newDoc);
    return newDoc;
  }

  @override
  Future<Document> updateDocument(Document document) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 700));
    
    final index = _documents.indexWhere((doc) => doc.id == document.id);
    if (index == -1) {
      throw Exception('Document non trouvé');
    }
    
    _documents[index] = document;
    return document;
  }

  @override
  Future<bool> deleteDocument(String id) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _documents.indexWhere((doc) => doc.id == id);
    if (index == -1) {
      return false;
    }
    
    _documents.removeAt(index);
    return true;
  }

  @override
  Future<Document> changeDocumentStatus(String id, DocumentStatus newStatus) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 400));
    
    final index = _documents.indexWhere((doc) => doc.id == id);
    if (index == -1) {
      throw Exception('Document non trouvé');
    }
    
    final updatedDoc = _documents[index].copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    
    _documents[index] = updatedDoc;
    return updatedDoc;
  }

  @override
  Future<List<DocumentTemplate>> getAllTemplates() async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));
    return [..._templates];
  }

  @override
  Future<DocumentTemplate?> getTemplateById(String id) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    return _templates.firstWhere((template) => template.id == id, orElse: () => throw Exception('Template not found'));
  }

  @override
  Future<List<DocumentTemplate>> getTemplatesByType(DocumentType type) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 400));
    return _templates.where((template) => template.type == type).toList();
  }

  @override
  Future<DocumentTemplate> addTemplate(DocumentTemplate template) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 700));
    
    final newTemplate = template.id.isEmpty 
        ? template.copyWith(id: _uuid.v4())
        : template;
    
    _templates.add(newTemplate);
    return newTemplate;
  }

  @override
  Future<DocumentTemplate> updateTemplate(DocumentTemplate template) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 700));
    
    final index = _templates.indexWhere((temp) => temp.id == template.id);
    if (index == -1) {
      throw Exception('Template non trouvé');
    }
    
    _templates[index] = template;
    return template;
  }

  @override
  Future<bool> deleteTemplate(String id) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _templates.indexWhere((temp) => temp.id == id);
    if (index == -1) {
      return false;
    }
    
    _templates.removeAt(index);
    return true;
  }

  @override
  Future<Document> generateDocumentFromTemplate({
    required String templateId,
    required Map<String, dynamic> data,
    required String title,
  }) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 900));
    
    // Trouver le template
    final template = await getTemplateById(templateId);
    if (template == null) {
      throw Exception('Template non trouvé');
    }
    
    // Générer le contenu à partir du template et des données
    String content = template.templateContent;
    
    // Remplacer les variables par les valeurs
    data.forEach((key, value) {
      content = content.replaceAll('{{$key}}', value.toString());
    });
    
    // Créer le nouveau document
    final newDocument = Document(
      id: _uuid.v4(),
      title: title,
      type: template.type,
      status: DocumentStatus.draft,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      content: content,
      data: Map<String, dynamic>.from(data),
    );
    
    // Ajouter le document à la liste
    _documents.add(newDocument);
    
    return newDocument;
  }
}
