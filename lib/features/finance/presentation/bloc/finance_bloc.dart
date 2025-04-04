import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../domain/entities/transaction.dart';

// Events
abstract class FinanceEvent extends Equatable {
  const FinanceEvent();

  @override
  List<Object> get props => [];
}

class FinanceInitialized extends FinanceEvent {
  const FinanceInitialized();
}

class FinanceTransactionAdded extends FinanceEvent {
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final String? clientId;

  const FinanceTransactionAdded({
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.clientId,
  });

  @override
  List<Object?> get props => [
    title, 
    description, 
    amount, 
    date, 
    type, 
    category, 
    clientId,
  ];
}

class FinanceInvoiceAdded extends FinanceEvent {
  final String invoiceNumber;
  final String clientName;
  final DateTime issueDate;
  final DateTime dueDate;
  final List<InvoiceItem> items;

  const FinanceInvoiceAdded({
    required this.invoiceNumber,
    required this.clientName,
    required this.issueDate,
    required this.dueDate,
    required this.items,
  });

  @override
  List<Object> get props => [
    invoiceNumber, 
    clientName, 
    issueDate, 
    dueDate, 
    items,
  ];
}

class FinanceInvoiceStatusUpdated extends FinanceEvent {
  final String invoiceId;
  final InvoiceStatus newStatus;

  const FinanceInvoiceStatusUpdated({
    required this.invoiceId,
    required this.newStatus,
  });

  @override
  List<Object> get props => [invoiceId, newStatus];
}

// States
abstract class FinanceState extends Equatable {
  const FinanceState();
  
  @override
  List<Object> get props => [];
}

class FinanceInitial extends FinanceState {
  const FinanceInitial();
}

class FinanceLoading extends FinanceState {
  const FinanceLoading();
}

class FinanceLoaded extends FinanceState {
  final List<Transaction> transactions;
  final List<Invoice> invoices;

  const FinanceLoaded({
    required this.transactions,
    required this.invoices,
  });

  FinanceLoaded copyWith({
    List<Transaction>? transactions,
    List<Invoice>? invoices,
  }) {
    return FinanceLoaded(
      transactions: transactions ?? this.transactions,
      invoices: invoices ?? this.invoices,
    );
  }

  @override
  List<Object> get props => [transactions, invoices];
}

class FinanceError extends FinanceState {
  final String message;

  const FinanceError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final SharedPreferences _preferences;
  static const String _transactionsKey = 'finance_transactions';
  static const String _invoicesKey = 'finance_invoices';
  final Uuid _uuid = const Uuid();

  FinanceBloc({required SharedPreferences preferences}) 
      : _preferences = preferences,
        super(const FinanceInitial()) {
    on<FinanceInitialized>(_onInitialized);
    on<FinanceTransactionAdded>(_onTransactionAdded);
    on<FinanceInvoiceAdded>(_onInvoiceAdded);
    on<FinanceInvoiceStatusUpdated>(_onInvoiceStatusUpdated);
  }

  Future<void> _onInitialized(
    FinanceInitialized event,
    Emitter<FinanceState> emit,
  ) async {
    emit(const FinanceLoading());

    try {
      final transactions = _loadTransactions();
      final invoices = _loadInvoices();
      
      // Si aucune donnée n'existe, créer des données de démonstration
      if (transactions.isEmpty && invoices.isEmpty) {
        _createDemoData();
        emit(const FinanceLoading());
        final newTransactions = _loadTransactions();
        final newInvoices = _loadInvoices();
        emit(FinanceLoaded(
          transactions: newTransactions,
          invoices: newInvoices,
        ));
      } else {
        emit(FinanceLoaded(
          transactions: transactions,
          invoices: invoices,
        ));
      }
    } catch (e) {
      emit(FinanceError(message: 'Erreur lors du chargement des données financières: $e'));
    }
  }

  Future<void> _onTransactionAdded(
    FinanceTransactionAdded event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      
      // Créer la nouvelle transaction
      final newTransaction = Transaction(
        id: _uuid.v4(),
        title: event.title,
        description: event.description,
        amount: event.amount,
        date: event.date,
        type: event.type,
        category: event.category,
        clientId: event.clientId,
      );
      
      // Ajouter à la liste existante
      final updatedTransactions = List<Transaction>.from(currentState.transactions)..add(newTransaction);
      
      // Mettre à jour l'état
      emit(currentState.copyWith(transactions: updatedTransactions));
      
      // Sauvegarder les transactions
      _saveTransactions(updatedTransactions);
    }
  }

  Future<void> _onInvoiceAdded(
    FinanceInvoiceAdded event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      
      // Calculer le montant total de la facture
      final totalAmount = event.items.fold<double>(
        0, 
        (sum, item) => sum + (item.quantity * item.unitPrice)
      );
      
      // Créer la nouvelle facture
      final newInvoice = Invoice(
        id: _uuid.v4(),
        invoiceNumber: event.invoiceNumber,
        clientName: event.clientName,
        amount: totalAmount,
        issueDate: event.issueDate,
        dueDate: event.dueDate,
        status: InvoiceStatus.draft,
        items: event.items,
      );
      
      // Ajouter à la liste existante
      final updatedInvoices = List<Invoice>.from(currentState.invoices)..add(newInvoice);
      
      // Mettre à jour l'état
      emit(currentState.copyWith(invoices: updatedInvoices));
      
      // Sauvegarder les factures
      _saveInvoices(updatedInvoices);
    }
  }

  Future<void> _onInvoiceStatusUpdated(
    FinanceInvoiceStatusUpdated event,
    Emitter<FinanceState> emit,
  ) async {
    if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      
      // Trouver la facture à mettre à jour
      final invoiceIndex = currentState.invoices.indexWhere((invoice) => invoice.id == event.invoiceId);
      
      if (invoiceIndex >= 0) {
        // Créer la liste mise à jour
        final updatedInvoices = List<Invoice>.from(currentState.invoices);
        
        // Mettre à jour la facture
        final invoice = updatedInvoices[invoiceIndex];
        updatedInvoices[invoiceIndex] = invoice.copyWith(status: event.newStatus);
        
        // Si la facture est marquée comme payée, créer une transaction de revenu
        if (event.newStatus == InvoiceStatus.paid) {
          final paymentTransaction = Transaction(
            id: _uuid.v4(),
            title: 'Paiement facture ${invoice.invoiceNumber}',
            description: 'Paiement reçu pour facture ${invoice.invoiceNumber} de ${invoice.clientName}',
            amount: invoice.amount,
            date: DateTime.now(),
            type: TransactionType.income,
            category: 'Paiement de facture',
            clientId: null,
          );
          
          final updatedTransactions = List<Transaction>.from(currentState.transactions)
            ..add(paymentTransaction);
          
          // Mettre à jour l'état avec les factures et transactions
          emit(currentState.copyWith(
            invoices: updatedInvoices,
            transactions: updatedTransactions,
          ));
          
          // Sauvegarder les transactions et factures
          _saveTransactions(updatedTransactions);
          _saveInvoices(updatedInvoices);
        } else {
          // Mettre à jour l'état avec les factures uniquement
          emit(currentState.copyWith(invoices: updatedInvoices));
          
          // Sauvegarder les factures
          _saveInvoices(updatedInvoices);
        }
      }
    }
  }

  List<Transaction> _loadTransactions() {
    final transactionsJson = _preferences.getStringList(_transactionsKey) ?? [];
    
    if (transactionsJson.isEmpty) {
      return [];
    }
    
    return transactionsJson.map((transactionStr) {
      final transactionMap = jsonDecode(transactionStr) as Map<String, dynamic>;
      return Transaction(
        id: transactionMap['id'] as String,
        title: transactionMap['title'] as String,
        description: transactionMap['description'] as String,
        amount: transactionMap['amount'] as double,
        date: DateTime.parse(transactionMap['date'] as String),
        type: TransactionType.values[transactionMap['type'] as int],
        category: transactionMap['category'] as String,
        clientId: transactionMap['clientId'] as String?,
      );
    }).toList();
  }

  void _saveTransactions(List<Transaction> transactions) {
    final transactionsJson = transactions.map((transaction) {
      return jsonEncode({
        'id': transaction.id,
        'title': transaction.title,
        'description': transaction.description,
        'amount': transaction.amount,
        'date': transaction.date.toIso8601String(),
        'type': transaction.type.index,
        'category': transaction.category,
        'clientId': transaction.clientId,
      });
    }).toList();
    
    _preferences.setStringList(_transactionsKey, transactionsJson);
  }

  List<Invoice> _loadInvoices() {
    final invoicesJson = _preferences.getStringList(_invoicesKey) ?? [];
    
    if (invoicesJson.isEmpty) {
      return [];
    }
    
    return invoicesJson.map((invoiceStr) {
      final invoiceMap = jsonDecode(invoiceStr) as Map<String, dynamic>;
      
      final itemsJson = invoiceMap['items'] as List<dynamic>;
      final items = itemsJson.map((itemJson) {
        final itemMap = itemJson as Map<String, dynamic>;
        return InvoiceItem(
          id: itemMap['id'] as String,
          description: itemMap['description'] as String,
          quantity: itemMap['quantity'] as double,
          unitPrice: itemMap['unitPrice'] as double,
          taxRate: itemMap['taxRate'] as double?,
        );
      }).toList();
      
      return Invoice(
        id: invoiceMap['id'] as String,
        invoiceNumber: invoiceMap['invoiceNumber'] as String,
        clientName: invoiceMap['clientName'] as String,
        amount: invoiceMap['amount'] as double,
        issueDate: DateTime.parse(invoiceMap['issueDate'] as String),
        dueDate: DateTime.parse(invoiceMap['dueDate'] as String),
        status: InvoiceStatus.values[invoiceMap['status'] as int],
        items: items,
      );
    }).toList();
  }

  void _saveInvoices(List<Invoice> invoices) {
    final invoicesJson = invoices.map((invoice) {
      final itemsJson = invoice.items.map((item) {
        return {
          'id': item.id,
          'description': item.description,
          'quantity': item.quantity,
          'unitPrice': item.unitPrice,
          'taxRate': item.taxRate,
        };
      }).toList();
      
      return jsonEncode({
        'id': invoice.id,
        'invoiceNumber': invoice.invoiceNumber,
        'clientName': invoice.clientName,
        'amount': invoice.amount,
        'issueDate': invoice.issueDate.toIso8601String(),
        'dueDate': invoice.dueDate.toIso8601String(),
        'status': invoice.status.index,
        'items': itemsJson,
      });
    }).toList();
    
    _preferences.setStringList(_invoicesKey, invoicesJson);
  }

  void _createDemoData() {
    // Créer des transactions de démonstration
    final now = DateTime.now();
    final transactions = [
      Transaction(
        id: _uuid.v4(),
        title: 'Paiement Client XYZ',
        description: 'Paiement pour services de conseil',
        amount: 1200.00,
        date: DateTime(now.year, now.month, now.day - 15),
        type: TransactionType.income,
        category: 'Services',
      ),
      Transaction(
        id: _uuid.v4(),
        title: 'Abonnement Logiciel',
        description: 'Abonnement mensuel suite bureautique',
        amount: 49.99,
        date: DateTime(now.year, now.month, now.day - 12),
        type: TransactionType.expense,
        category: 'Abonnements',
      ),
      Transaction(
        id: _uuid.v4(),
        title: 'Paiement Client ABC',
        description: 'Paiement pour projet de développement',
        amount: 850.00,
        date: DateTime(now.year, now.month, now.day - 8),
        type: TransactionType.income,
        category: 'Développement',
      ),
      Transaction(
        id: _uuid.v4(),
        title: 'Fournitures Bureau',
        description: 'Achat de matériel de bureau',
        amount: 120.50,
        date: DateTime(now.year, now.month, now.day - 5),
        type: TransactionType.expense,
        category: 'Fournitures',
      ),
    ];
    
    // Créer des factures de démonstration
    final invoices = [
      Invoice(
        id: _uuid.v4(),
        invoiceNumber: 'INV-001',
        clientName: 'Entreprise XYZ',
        amount: 1200.00,
        issueDate: DateTime(now.year, now.month, now.day - 15),
        dueDate: DateTime(now.year, now.month, now.day + 15),
        status: InvoiceStatus.paid,
        items: [
          InvoiceItem(
            id: _uuid.v4(),
            description: 'Service de conseil',
            quantity: 8,
            unitPrice: 150.00,
          ),
        ],
      ),
      Invoice(
        id: _uuid.v4(),
        invoiceNumber: 'INV-002',
        clientName: 'Client ABC',
        amount: 850.00,
        issueDate: DateTime(now.year, now.month, now.day - 8),
        dueDate: DateTime(now.year, now.month, now.day + 22),
        status: InvoiceStatus.paid,
        items: [
          InvoiceItem(
            id: _uuid.v4(),
            description: 'Développement de fonctionnalité',
            quantity: 1,
            unitPrice: 850.00,
          ),
        ],
      ),
      Invoice(
        id: _uuid.v4(),
        invoiceNumber: 'INV-003',
        clientName: 'Société DEF',
        amount: 1500.00,
        issueDate: DateTime(now.year, now.month, now.day - 3),
        dueDate: DateTime(now.year, now.month, now.day + 27),
        status: InvoiceStatus.sent,
        items: [
          InvoiceItem(
            id: _uuid.v4(),
            description: 'Audit et recommandations',
            quantity: 1,
            unitPrice: 1000.00,
          ),
          InvoiceItem(
            id: _uuid.v4(),
            description: 'Formation équipe',
            quantity: 2,
            unitPrice: 250.00,
          ),
        ],
      ),
      Invoice(
        id: _uuid.v4(),
        invoiceNumber: 'INV-004',
        clientName: 'Client GHI',
        amount: 750.00,
        issueDate: DateTime(now.year, now.month, now.day - 1),
        dueDate: DateTime(now.year, now.month, now.day + 29),
        status: InvoiceStatus.sent,
        items: [
          InvoiceItem(
            id: _uuid.v4(),
            description: 'Consultation stratégique',
            quantity: 5,
            unitPrice: 150.00,
          ),
        ],
      ),
      Invoice(
        id: _uuid.v4(),
        invoiceNumber: 'INV-005',
        clientName: 'Entreprise JKL',
        amount: 1800.00,
        issueDate: DateTime(now.year, now.month, now.day + 2),
        dueDate: DateTime(now.year, now.month, now.day + 32),
        status: InvoiceStatus.draft,
        items: [
          InvoiceItem(
            id: _uuid.v4(),
            description: 'Développement de site web',
            quantity: 1,
            unitPrice: 1800.00,
          ),
        ],
      ),
    ];
    
    // Sauvegarder les données
    _saveTransactions(transactions);
    _saveInvoices(invoices);
  }
}
