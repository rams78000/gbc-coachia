import 'package:equatable/equatable.dart';

/// Enum représentant les différents modules que l'IA peut consulter
enum AIModuleType {
  finance,
  planner,
  documents,
  dashboard,
  settings,
}

/// Représente une fonctionnalité ou une action spécifique que l'IA peut effectuer
/// dans un module particulier de l'application
class AIModuleFeature extends Equatable {
  final String id;
  final String name;
  final String description;
  final AIModuleType module;
  final String functionName;
  final Map<String, dynamic> parameters;
  final bool requiresConfirmation;

  const AIModuleFeature({
    required this.id,
    required this.name,
    required this.description,
    required this.module,
    required this.functionName,
    this.parameters = const {},
    this.requiresConfirmation = true,
  });

  @override
  List<Object?> get props => [id, name, description, module, functionName, parameters, requiresConfirmation];

  /// Convertit la fonctionnalité en une fonction définie selon le format OpenAI
  Map<String, dynamic> toFunctionDefinition() {
    return {
      'name': functionName,
      'description': description,
      'parameters': parameters,
    };
  }

  /// Liste des fonctionnalités de base disponibles pour l'IA
  static List<AIModuleFeature> getDefaultFeatures() {
    return [
      // Finance
      AIModuleFeature(
        id: 'get_financial_summary',
        name: 'Récupérer le résumé financier',
        description: 'Récupère un résumé des données financières actuelles de l\'entreprise',
        module: AIModuleType.finance,
        functionName: 'getFinancialSummary',
        parameters: {
          'type': 'object',
          'properties': {
            'period': {
              'type': 'string',
              'enum': ['day', 'week', 'month', 'year', 'all'],
              'description': 'Période pour laquelle récupérer les données financières',
            },
          },
          'required': ['period'],
        },
      ),
      AIModuleFeature(
        id: 'create_transaction',
        name: 'Créer une transaction',
        description: 'Crée une nouvelle transaction financière',
        module: AIModuleType.finance,
        functionName: 'createTransaction',
        parameters: {
          'type': 'object',
          'properties': {
            'title': {
              'type': 'string',
              'description': 'Titre de la transaction',
            },
            'amount': {
              'type': 'number',
              'description': 'Montant de la transaction',
            },
            'is_income': {
              'type': 'boolean',
              'description': 'Indique s\'il s\'agit d\'un revenu (true) ou d\'une dépense (false)',
            },
            'category': {
              'type': 'string',
              'description': 'Catégorie de la transaction',
            },
            'date': {
              'type': 'string',
              'format': 'date',
              'description': 'Date de la transaction (YYYY-MM-DD)',
            },
            'description': {
              'type': 'string',
              'description': 'Description optionnelle de la transaction',
            },
          },
          'required': ['title', 'amount', 'is_income', 'category', 'date'],
        },
      ),
      
      // Planner
      AIModuleFeature(
        id: 'get_upcoming_events',
        name: 'Récupérer les événements à venir',
        description: 'Récupère la liste des événements à venir dans un intervalle de temps',
        module: AIModuleType.planner,
        functionName: 'getUpcomingEvents',
        parameters: {
          'type': 'object',
          'properties': {
            'days': {
              'type': 'integer',
              'description': 'Nombre de jours à partir d\'aujourd\'hui',
              'default': 7,
            },
          },
        },
      ),
      AIModuleFeature(
        id: 'create_event',
        name: 'Créer un événement',
        description: 'Crée un nouvel événement dans le calendrier',
        module: AIModuleType.planner,
        functionName: 'createEvent',
        parameters: {
          'type': 'object',
          'properties': {
            'title': {
              'type': 'string',
              'description': 'Titre de l\'événement',
            },
            'start_date': {
              'type': 'string',
              'format': 'date-time',
              'description': 'Date et heure de début (ISO-8601)',
            },
            'end_date': {
              'type': 'string',
              'format': 'date-time',
              'description': 'Date et heure de fin (ISO-8601)',
            },
            'category': {
              'type': 'string',
              'description': 'Catégorie de l\'événement',
              'enum': ['client', 'meeting', 'deadline', 'task', 'reminder', 'personal'],
            },
            'description': {
              'type': 'string',
              'description': 'Description de l\'événement',
            },
            'location': {
              'type': 'string',
              'description': 'Lieu de l\'événement',
            },
            'is_all_day': {
              'type': 'boolean',
              'description': 'Indique si l\'événement dure toute la journée',
              'default': false,
            },
          },
          'required': ['title', 'start_date', 'category'],
        },
      ),
      
      // Documents
      AIModuleFeature(
        id: 'search_documents',
        name: 'Rechercher des documents',
        description: 'Recherche des documents selon des critères spécifiques',
        module: AIModuleType.documents,
        functionName: 'searchDocuments',
        parameters: {
          'type': 'object',
          'properties': {
            'query': {
              'type': 'string',
              'description': 'Texte à rechercher dans les documents',
            },
            'document_type': {
              'type': 'string',
              'description': 'Type de document à filtrer',
              'enum': ['all', 'invoice', 'contract', 'report', 'receipt', 'proposal', 'legal', 'tax', 'image', 'pdf', 'spreadsheet', 'presentation', 'text', 'other'],
              'default': 'all',
            },
            'max_results': {
              'type': 'integer',
              'description': 'Nombre maximum de résultats à retourner',
              'default': 10,
            },
          },
          'required': ['query'],
        },
      ),
      
      // Dashboard
      AIModuleFeature(
        id: 'get_business_insights',
        name: 'Obtenir des insights sur l\'entreprise',
        description: 'Récupère des analyses et des insights sur l\'état actuel de l\'entreprise',
        module: AIModuleType.dashboard,
        functionName: 'getBusinessInsights',
        parameters: {
          'type': 'object',
          'properties': {
            'focus_area': {
              'type': 'string',
              'description': 'Domaine sur lequel concentrer l\'analyse',
              'enum': ['finance', 'productivity', 'growth', 'operations', 'all'],
              'default': 'all',
            },
          },
        },
      ),
    ];
  }
}
