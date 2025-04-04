import 'dart:convert';

import 'package:gbc_coachia/features/chatbot/data/sources/chatbot_local_source.dart';
import 'package:gbc_coachia/features/chatbot/data/sources/chatbot_remote_source.dart';
import 'package:gbc_coachia/features/chatbot/domain/entities/ai_module_feature.dart';
import 'package:gbc_coachia/features/chatbot/domain/entities/conversation.dart';
import 'package:gbc_coachia/features/chatbot/domain/entities/message.dart';
import 'package:gbc_coachia/features/chatbot/domain/repositories/chatbot_repository.dart';
import 'package:gbc_coachia/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:gbc_coachia/features/documents/domain/repositories/document_repository.dart';
import 'package:gbc_coachia/features/finance/domain/repositories/transaction_repository.dart';
import 'package:gbc_coachia/features/planner/domain/repositories/event_repository.dart';
import 'package:uuid/uuid.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteSource _remoteSource;
  final ChatbotLocalSource _localSource;
  final TransactionRepository? _transactionRepository;
  final EventRepository? _eventRepository;
  final DocumentRepository? _documentRepository;
  final DashboardRepository? _dashboardRepository;

  ChatbotRepositoryImpl({
    required ChatbotRemoteSource remoteSource,
    required ChatbotLocalSource localSource,
    TransactionRepository? transactionRepository,
    EventRepository? eventRepository,
    DocumentRepository? documentRepository,
    DashboardRepository? dashboardRepository,
  })  : _remoteSource = remoteSource,
        _localSource = localSource,
        _transactionRepository = transactionRepository,
        _eventRepository = eventRepository,
        _documentRepository = documentRepository,
        _dashboardRepository = dashboardRepository;

  @override
  Future<List<Conversation>> getConversations() async {
    return await _localSource.getConversations();
  }

  @override
  Future<Conversation?> getConversationById(String id) async {
    return await _localSource.getConversationById(id);
  }

  @override
  Future<Conversation> createConversation(String title) async {
    return await _localSource.createConversation(title);
  }

  @override
  Future<void> deleteConversation(String id) async {
    await _localSource.deleteConversation(id);
  }

  @override
  Future<Message> sendMessage(
    String conversationId,
    String content, {
    bool useFeatures = true,
  }) async {
    try {
      // Récupérer la conversation
      final conversation = await _localSource.getConversationById(conversationId);
      if (conversation == null) {
        throw Exception('Conversation non trouvée');
      }

      // Créer un nouveau message utilisateur
      final userMessage = Message(
        id: const Uuid().v4(),
        content: content,
        role: MessageRole.user,
        timestamp: DateTime.now(),
      );

      // Ajouter le message de l'utilisateur à la conversation
      await _localSource.addMessageToConversation(conversationId, userMessage);

      // Créer un message de chargement
      final loadingMessage = Message(
        id: const Uuid().v4(),
        content: 'Chargement...',
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
        isLoading: true,
      );

      // Ajouter le message de chargement temporaire
      await _localSource.addMessageToConversation(conversationId, loadingMessage);

      // Récupérer les fonctionnalités disponibles si nécessaire
      final features = useFeatures ? AIModuleFeature.getDefaultFeatures() : null;

      // Envoyer la demande à l'API
      final aiResponse = await _remoteSource.sendMessage(
        [...conversation.messages, userMessage],
        features: features,
      );

      // Si l'IA a appelé une fonction, l'exécuter
      Message finalResponse = aiResponse;
      if (_isFunctionCall(aiResponse.content)) {
        finalResponse = await _processFunctionCall(aiResponse, conversationId);
      }

      // Supprimer le message de chargement et ajouter la réponse finale
      final updatedConversation = await _localSource.getConversationById(conversationId);
      if (updatedConversation != null) {
        final messages = updatedConversation.messages.where((m) => m.id != loadingMessage.id).toList();
        
        // Mettre à jour la conversation avec les messages sans le chargement
        await _localSource.saveConversation(
          updatedConversation.copyWith(
            messages: messages,
            updatedAt: DateTime.now(),
          ),
        );
        
        // Ajouter la réponse finale
        await _localSource.addMessageToConversation(conversationId, finalResponse);
      }

      return finalResponse;
    } catch (e) {
      // En cas d'erreur, créer un message d'erreur
      final errorMessage = Message(
        id: const Uuid().v4(),
        content: 'Erreur: ${e.toString()}',
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );

      // Mettre à jour la conversation avec le message d'erreur
      await _localSource.addMessageToConversation(conversationId, errorMessage);
      return errorMessage;
    }
  }

  @override
  Future<bool> isApiKeyValid() async {
    return await _remoteSource.isApiKeyValid();
  }

  @override
  Future<void> setApiKey(String apiKey) async {
    await _remoteSource.setApiKey(apiKey);
  }

  // Détermine si un message contient un appel de fonction
  bool _isFunctionCall(String content) {
    try {
      final decoded = jsonDecode(content);
      return decoded is Map<String, dynamic> && decoded.containsKey('function_name');
    } catch (e) {
      return false;
    }
  }

  // Traite un appel de fonction par l'IA
  Future<Message> _processFunctionCall(Message functionCallMessage, String conversationId) async {
    try {
      final decoded = jsonDecode(functionCallMessage.content);
      final functionName = decoded['function_name'];
      final arguments = jsonDecode(decoded['arguments']);
      final explanation = decoded['explanation'] ?? '';

      String result = '';
      bool success = false;

      // Exécuter la fonction appropriée en fonction du nom
      switch (functionName) {
        case 'getFinancialSummary':
          if (_transactionRepository != null) {
            result = await _getFinancialSummary(arguments['period']);
            success = true;
          } else {
            result = 'Module financier non disponible.';
          }
          break;

        case 'createTransaction':
          if (_transactionRepository != null) {
            result = await _createTransaction(arguments);
            success = true;
          } else {
            result = 'Module financier non disponible.';
          }
          break;

        case 'getUpcomingEvents':
          if (_eventRepository != null) {
            result = await _getUpcomingEvents(arguments['days'] ?? 7);
            success = true;
          } else {
            result = 'Module de planification non disponible.';
          }
          break;

        case 'createEvent':
          if (_eventRepository != null) {
            result = await _createEvent(arguments);
            success = true;
          } else {
            result = 'Module de planification non disponible.';
          }
          break;

        case 'searchDocuments':
          if (_documentRepository != null) {
            result = await _searchDocuments(arguments);
            success = true;
          } else {
            result = 'Module de documents non disponible.';
          }
          break;

        case 'getBusinessInsights':
          if (_dashboardRepository != null) {
            result = await _getBusinessInsights(arguments['focus_area'] ?? 'all');
            success = true;
          } else {
            result = 'Module de tableau de bord non disponible.';
          }
          break;

        default:
          result = 'Fonction non reconnue: $functionName';
      }

      // Créer le message de réponse
      final responseContent = success
          ? '$explanation\n\n$result'
          : 'Je ne peux pas exécuter cette action pour le moment. $result';

      return Message(
        id: const Uuid().v4(),
        content: responseContent,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return Message(
        id: const Uuid().v4(),
        content: 'Erreur lors du traitement de l\'action: ${e.toString()}',
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );
    }
  }

  // Fonctions d'exécution des appels de l'IA

  Future<String> _getFinancialSummary(String period) async {
    if (_transactionRepository == null) {
      return 'Module financier non disponible.';
    }

    try {
      final transactions = await _transactionRepository.getAllTransactions();
      
      // Filtrer les transactions en fonction de la période
      final now = DateTime.now();
      List filteredTransactions = [];
      
      switch (period) {
        case 'day':
          filteredTransactions = transactions.where((t) => 
            t.date.year == now.year && 
            t.date.month == now.month && 
            t.date.day == now.day
          ).toList();
          break;
        case 'week':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          filteredTransactions = transactions.where((t) => 
            t.date.isAfter(weekStart.subtract(const Duration(days: 1))) || 
            (t.date.day == weekStart.day && t.date.month == weekStart.month && t.date.year == weekStart.year)
          ).toList();
          break;
        case 'month':
          filteredTransactions = transactions.where((t) => 
            t.date.year == now.year && 
            t.date.month == now.month
          ).toList();
          break;
        case 'year':
          filteredTransactions = transactions.where((t) => 
            t.date.year == now.year
          ).toList();
          break;
        case 'all':
        default:
          filteredTransactions = transactions;
      }
      
      // Calculer les totaux
      double income = 0;
      double expenses = 0;
      
      for (final transaction in filteredTransactions) {
        if (transaction.isIncome) {
          income += transaction.amount;
        } else {
          expenses += transaction.amount;
        }
      }
      
      final balance = income - expenses;
      
      // Formater le résultat
      return '''
Résumé financier pour la période: ${_formatPeriod(period)}

- Revenus: ${_formatAmount(income)}
- Dépenses: ${_formatAmount(expenses)}
- Solde: ${_formatAmount(balance)}
- Nombre de transactions: ${filteredTransactions.length}
''';
    } catch (e) {
      return 'Erreur lors de la récupération du résumé financier: $e';
    }
  }

  Future<String> _createTransaction(Map<String, dynamic> arguments) async {
    if (_transactionRepository == null) {
      return 'Module financier non disponible.';
    }

    try {
      final title = arguments['title'];
      final amount = arguments['amount'];
      final isIncome = arguments['is_income'];
      final category = arguments['category'];
      final date = DateTime.parse(arguments['date']);
      final description = arguments['description'] ?? '';
      
      await _transactionRepository.addTransaction(
        title: title,
        amount: amount,
        isIncome: isIncome,
        category: category,
        date: date,
        description: description,
      );
      
      return '''
Transaction ajoutée avec succès:
- Titre: $title
- Montant: ${_formatAmount(amount)}
- Type: ${isIncome ? 'Revenu' : 'Dépense'}
- Catégorie: $category
- Date: ${_formatDate(date)}
''';
    } catch (e) {
      return 'Erreur lors de la création de la transaction: $e';
    }
  }

  Future<String> _getUpcomingEvents(int days) async {
    if (_eventRepository == null) {
      return 'Module de planification non disponible.';
    }

    try {
      final now = DateTime.now();
      final endDate = now.add(Duration(days: days));
      
      final events = await _eventRepository.getEventsBetweenDates(now, endDate);
      
      if (events.isEmpty) {
        return 'Aucun événement à venir dans les $days prochains jours.';
      }
      
      final eventsFormatted = events.map((event) {
        final dateStr = _formatDate(event.start);
        final timeStr = _formatTime(event.start);
        return '- $dateStr à $timeStr: ${event.title} (${event.category})';
      }).join('\n');
      
      return '''
Événements à venir pour les $days prochains jours:

$eventsFormatted
''';
    } catch (e) {
      return 'Erreur lors de la récupération des événements: $e';
    }
  }

  Future<String> _createEvent(Map<String, dynamic> arguments) async {
    if (_eventRepository == null) {
      return 'Module de planification non disponible.';
    }

    try {
      final title = arguments['title'];
      final startDate = DateTime.parse(arguments['start_date']);
      final endDate = arguments.containsKey('end_date') && arguments['end_date'] != null
          ? DateTime.parse(arguments['end_date'])
          : startDate.add(const Duration(hours: 1));
      final category = arguments['category'];
      final description = arguments['description'] ?? '';
      final location = arguments['location'] ?? '';
      final isAllDay = arguments['is_all_day'] ?? false;
      
      await _eventRepository.addEvent(
        title: title,
        start: startDate,
        end: endDate,
        category: category,
        description: description,
        location: location,
        isAllDay: isAllDay,
      );
      
      return '''
Événement ajouté avec succès:
- Titre: $title
- Date: ${_formatDate(startDate)}
- Heure: ${_formatTime(startDate)} - ${_formatTime(endDate)}
- Catégorie: $category
- Lieu: ${location.isEmpty ? 'Non spécifié' : location}
''';
    } catch (e) {
      return 'Erreur lors de la création de l\'événement: $e';
    }
  }

  Future<String> _searchDocuments(Map<String, dynamic> arguments) async {
    if (_documentRepository == null) {
      return 'Module de documents non disponible.';
    }

    try {
      final query = arguments['query'];
      final documentType = arguments['document_type'] ?? 'all';
      final maxResults = arguments['max_results'] ?? 10;
      
      final documents = await _documentRepository.searchDocuments(
        query: query,
        type: documentType != 'all' ? documentType : null,
        limit: maxResults,
      );
      
      if (documents.isEmpty) {
        return 'Aucun document ne correspond à votre recherche "$query".';
      }
      
      final documentsFormatted = documents.map((doc) {
        final dateStr = _formatDate(doc.createdAt);
        return '- ${doc.name} (${doc.type}) - Ajouté le $dateStr';
      }).join('\n');
      
      return '''
Résultats de la recherche pour "$query":

$documentsFormatted
''';
    } catch (e) {
      return 'Erreur lors de la recherche de documents: $e';
    }
  }

  Future<String> _getBusinessInsights(String focusArea) async {
    if (_dashboardRepository == null) {
      return 'Module de tableau de bord non disponible.';
    }

    try {
      final dashboardData = await _dashboardRepository.getDashboardData();
      final financialOverview = dashboardData.financialOverview;
      final activitySummary = dashboardData.activitySummary;
      
      String insights = '';
      
      switch (focusArea) {
        case 'finance':
          insights = '''
Aperçu financier:
- Solde actuel: ${_formatAmount(financialOverview.currentBalance)}
- Revenus ce mois-ci: ${_formatAmount(financialOverview.incomeThisMonth)}
- Dépenses ce mois-ci: ${_formatAmount(financialOverview.expensesThisMonth)}
- Paiements en attente: ${_formatAmount(financialOverview.pendingInvoices)}

Tendance: ${_getTrend(financialOverview)}
''';
          break;
        
        case 'productivity':
          insights = '''
Résumé d'activité:
- Événements: ${activitySummary.completedEvents}/${activitySummary.totalEvents} complétés
- Documents: ${activitySummary.totalDocuments} documents gérés
- Taux de complétion: ${_getCompletionRate(activitySummary)}%
''';
          break;
        
        case 'all':
        default:
          insights = '''
Aperçu général:

Finances:
- Solde actuel: ${_formatAmount(financialOverview.currentBalance)}
- Revenus ce mois-ci: ${_formatAmount(financialOverview.incomeThisMonth)}
- Dépenses ce mois-ci: ${_formatAmount(financialOverview.expensesThisMonth)}

Activité:
- Événements: ${activitySummary.completedEvents}/${activitySummary.totalEvents} complétés
- Documents: ${activitySummary.totalDocuments} documents gérés
- Transactions: ${activitySummary.totalTransactions} transactions enregistrées

Prochains événements: ${dashboardData.upcomingEvents.isEmpty ? 'Aucun événement à venir' : '${dashboardData.upcomingEvents.length} événements à venir'}
''';
      }
      
      return insights;
    } catch (e) {
      return 'Erreur lors de la récupération des insights: $e';
    }
  }

  // Méthodes utilitaires pour le formatage

  String _formatPeriod(String period) {
    switch (period) {
      case 'day':
        return 'aujourd\'hui';
      case 'week':
        return 'cette semaine';
      case 'month':
        return 'ce mois-ci';
      case 'year':
        return 'cette année';
      case 'all':
      default:
        return 'ensemble';
    }
  }

  String _formatAmount(double amount) {
    return '${amount.toStringAsFixed(2)} €';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getTrend(FinancialOverview financialOverview) {
    if (financialOverview.monthlySummary.length < 2) {
      return 'Données insuffisantes pour dégager une tendance';
    }
    
    final lastMonth = financialOverview.monthlySummary.last;
    final previousMonth = financialOverview.monthlySummary[financialOverview.monthlySummary.length - 2];
    
    final lastBalance = lastMonth.income - lastMonth.expenses;
    final previousBalance = previousMonth.income - previousMonth.expenses;
    
    if (lastBalance > previousBalance) {
      return 'En augmentation par rapport au mois précédent';
    } else if (lastBalance < previousBalance) {
      return 'En diminution par rapport au mois précédent';
    } else {
      return 'Stable par rapport au mois précédent';
    }
  }

  int _getCompletionRate(ActivitySummary activitySummary) {
    if (activitySummary.totalEvents == 0) {
      return 0;
    }
    
    return ((activitySummary.completedEvents / activitySummary.totalEvents) * 100).round();
  }
}
