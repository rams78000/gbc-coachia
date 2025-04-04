import 'dart:math';
import 'package:uuid/uuid.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/financial_summary.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finance_repository.dart';

/// Implémentation du repository des finances avec des données fictives
class MockFinanceRepository implements FinanceRepository {
  final _uuid = const Uuid();
  
  // Données fictives pour le développement
  final List<Transaction> _transactions = [];
  final List<Account> _accounts = [];
  
  // Constructeur
  MockFinanceRepository() {
    _initializeMockData();
  }
  
  /// Initialise des données fictives
  void _initializeMockData() {
    // Créer des comptes fictifs
    final currentAccount = Account.create(
      id: _uuid.v4(),
      name: 'Compte courant',
      type: AccountType.checking,
      initialBalance: 3750.0,
      currency: 'EUR',
      institution: 'Banque XYZ',
    );
    
    final savingsAccount = Account.create(
      id: _uuid.v4(),
      name: 'Livret d\'épargne',
      type: AccountType.savings,
      initialBalance: 12500.0,
      currency: 'EUR',
      institution: 'Banque XYZ',
    );
    
    final creditCard = Account.create(
      id: _uuid.v4(),
      name: 'Carte professionnelle',
      type: AccountType.creditCard,
      initialBalance: -450.0,
      currency: 'EUR',
      institution: 'Banque ABC',
    );
    
    _accounts.addAll([currentAccount, savingsAccount, creditCard]);
    
    // Créer des transactions fictives
    final now = DateTime.now();
    final random = Random();
    
    // Transactions du mois actuel
    for (int i = 0; i < 30; i++) {
      final isIncome = random.nextBool();
      
      if (isIncome) {
        // Revenus
        _transactions.add(Transaction.income(
          id: _uuid.v4(),
          title: _getRandomIncomeTitle(),
          amount: 100.0 + random.nextDouble() * 900,
          category: _getRandomIncomeCategory(),
          date: DateTime(now.year, now.month, random.nextInt(28) + 1),
          accountId: currentAccount.id,
        ));
      } else {
        // Dépenses
        _transactions.add(Transaction.expense(
          id: _uuid.v4(),
          title: _getRandomExpenseTitle(),
          amount: 10.0 + random.nextDouble() * 200,
          category: _getRandomExpenseCategory(),
          date: DateTime(now.year, now.month, random.nextInt(28) + 1),
          accountId: random.nextBool() ? currentAccount.id : creditCard.id,
        ));
      }
    }
    
    // Ajouter quelques transactions pour le mois précédent
    for (int i = 0; i < 20; i++) {
      final isIncome = random.nextBool();
      final previousMonth = now.month > 1 ? now.month - 1 : 12;
      final year = now.month > 1 ? now.year : now.year - 1;
      
      if (isIncome) {
        _transactions.add(Transaction.income(
          id: _uuid.v4(),
          title: _getRandomIncomeTitle(),
          amount: 100.0 + random.nextDouble() * 900,
          category: _getRandomIncomeCategory(),
          date: DateTime(year, previousMonth, random.nextInt(28) + 1),
          accountId: currentAccount.id,
        ));
      } else {
        _transactions.add(Transaction.expense(
          id: _uuid.v4(),
          title: _getRandomExpenseTitle(),
          amount: 10.0 + random.nextDouble() * 200,
          category: _getRandomExpenseCategory(),
          date: DateTime(year, previousMonth, random.nextInt(28) + 1),
          accountId: random.nextBool() ? currentAccount.id : creditCard.id,
        ));
      }
    }
    
    // Trier les transactions par date (les plus récentes d'abord)
    _transactions.sort((a, b) => b.date.compareTo(a.date));
  }
  
  /// Génère un titre de revenu aléatoire
  String _getRandomIncomeTitle() {
    final titles = [
      'Paiement client',
      'Honoraires',
      'Vente de produit',
      'Prestation de service',
      'Commission',
      'Remboursement',
      'Dividende',
      'Intérêt',
    ];
    return titles[Random().nextInt(titles.length)];
  }
  
  /// Génère un titre de dépense aléatoire
  String _getRandomExpenseTitle() {
    final titles = [
      'Fournitures de bureau',
      'Repas d\'affaires',
      'Abonnement logiciel',
      'Transport',
      'Publicité',
      'Loyer',
      'Téléphone',
      'Internet',
      'Matériel informatique',
      'Formation',
      'Assurance',
    ];
    return titles[Random().nextInt(titles.length)];
  }
  
  /// Génère une catégorie de revenu aléatoire
  TransactionCategory _getRandomIncomeCategory() {
    final categories = [
      TransactionCategory.freelance,
      TransactionCategory.sale,
      TransactionCategory.investment,
      TransactionCategory.refund,
      TransactionCategory.other_income,
    ];
    return categories[Random().nextInt(categories.length)];
  }
  
  /// Génère une catégorie de dépense aléatoire
  TransactionCategory _getRandomExpenseCategory() {
    final categories = [
      TransactionCategory.rent,
      TransactionCategory.utilities,
      TransactionCategory.food,
      TransactionCategory.transportation,
      TransactionCategory.marketing,
      TransactionCategory.software,
      TransactionCategory.supplies,
      TransactionCategory.fees,
      TransactionCategory.taxes,
      TransactionCategory.other_expense,
    ];
    return categories[Random().nextInt(categories.length)];
  }
  
  @override
  Future<Transaction> addTransaction(Transaction transaction) async {
    final newTransaction = transaction.copyWith(
      id: transaction.id.isEmpty ? _uuid.v4() : transaction.id,
    );
    _transactions.add(newTransaction);
    
    // Mettre à jour le solde du compte
    _updateAccountBalance(
      transaction.accountId ?? '',
      transaction.type == TransactionType.income 
          ? transaction.amount 
          : -transaction.amount,
    );
    
    // Trier les transactions par date
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    
    return newTransaction;
  }
  
  @override
  Future<Account> addAccount(Account account) async {
    final newAccount = account.copyWith(
      id: account.id.isEmpty ? _uuid.v4() : account.id,
    );
    _accounts.add(newAccount);
    return newAccount;
  }
  
  @override
  Future<bool> deleteAccount(String id) async {
    final initialLength = _accounts.length;
    _accounts.removeWhere((account) => account.id == id);
    return _accounts.length < initialLength;
  }
  
  @override
  Future<bool> deleteTransaction(String id) async {
    final transaction = _transactions.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Transaction non trouvée'),
    );
    
    // Mettre à jour le solde du compte
    if (transaction.accountId != null) {
      _updateAccountBalance(
        transaction.accountId!,
        transaction.type == TransactionType.income 
            ? -transaction.amount 
            : transaction.amount,
      );
    }
    
    final initialLength = _transactions.length;
    _transactions.removeWhere((t) => t.id == id);
    return _transactions.length < initialLength;
  }
  
  @override
  Future<Account?> getAccountById(String id) async {
    try {
      return _accounts.firstWhere((account) => account.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<List<Account>> getAccounts() async {
    return [..._accounts];
  }
  
  @override
  Future<List<Transaction>> getFilteredTransactions({
    TransactionType? type,
    TransactionCategory? category,
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
    String? searchQuery,
  }) async {
    return _transactions.where((transaction) {
      // Filtrer par type
      if (type != null && transaction.type != type) {
        return false;
      }
      
      // Filtrer par catégorie
      if (category != null && transaction.category != category) {
        return false;
      }
      
      // Filtrer par date de début
      if (startDate != null && transaction.date.isBefore(startDate)) {
        return false;
      }
      
      // Filtrer par date de fin
      if (endDate != null && transaction.date.isAfter(endDate)) {
        return false;
      }
      
      // Filtrer par compte
      if (accountId != null && transaction.accountId != accountId) {
        return false;
      }
      
      // Filtrer par recherche
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        if (!transaction.title.toLowerCase().contains(query) &&
            !(transaction.description?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }
      
      return true;
    }).toList();
  }
  
  @override
  Future<FinancialSummary> getFinancialSummary({
    required DateTime startDate,
    required DateTime endDate,
    double? budgetAmount,
  }) async {
    final transactions = await getFilteredTransactions(
      startDate: startDate,
      endDate: endDate,
    );
    
    return FinancialSummary.fromTransactions(
      transactions: transactions,
      startDate: startDate,
      endDate: endDate,
      budgetAmount: budgetAmount,
    );
  }
  
  @override
  Future<List<FinancialSummary>> getFinancialTrends({
    required FinancialPeriod period,
    required int count,
    DateTime? endDate,
  }) async {
    final result = <FinancialSummary>[];
    final end = endDate ?? DateTime.now();
    
    for (int i = 0; i < count; i++) {
      DateTime periodEnd;
      DateTime periodStart;
      
      switch (period) {
        case FinancialPeriod.daily:
          periodEnd = end.subtract(Duration(days: i));
          periodStart = end.subtract(Duration(days: i + 1));
          break;
        case FinancialPeriod.weekly:
          periodEnd = end.subtract(Duration(days: i * 7));
          periodStart = end.subtract(Duration(days: (i + 1) * 7));
          break;
        case FinancialPeriod.monthly:
          final year = end.year - (end.month - 1 + i) ~/ 12;
          final month = (end.month - 1 - i) % 12 + 1;
          final nextMonth = month == 12 ? 1 : month + 1;
          final nextMonthYear = month == 12 ? year + 1 : year;
          
          periodStart = DateTime(year, month, 1);
          periodEnd = DateTime(nextMonthYear, nextMonth, 1).subtract(const Duration(days: 1));
          break;
        case FinancialPeriod.quarterly:
          final baseQuarter = ((end.month - 1) ~/ 3);
          final targetQuarter = (baseQuarter - i) % 4;
          final yearOffset = (baseQuarter - i) ~/ 4;
          final year = end.year - yearOffset;
          
          final startMonth = targetQuarter * 3 + 1;
          final endMonth = startMonth + 2;
          
          periodStart = DateTime(year, startMonth, 1);
          if (endMonth == 12) {
            periodEnd = DateTime(year + 1, 1, 1).subtract(const Duration(days: 1));
          } else {
            periodEnd = DateTime(year, endMonth + 1, 1).subtract(const Duration(days: 1));
          }
          break;
        case FinancialPeriod.yearly:
          periodStart = DateTime(end.year - i, 1, 1);
          periodEnd = DateTime(end.year - i + 1, 1, 1).subtract(const Duration(days: 1));
          break;
        default: // custom
          periodEnd = end.subtract(Duration(days: i * 30));
          periodStart = end.subtract(Duration(days: (i + 1) * 30));
      }
      
      final summary = await getFinancialSummary(
        startDate: periodStart,
        endDate: periodEnd,
      );
      
      result.add(summary);
    }
    
    return result;
  }
  
  @override
  Future<Transaction?> getTransactionById(String id) async {
    try {
      return _transactions.firstWhere((transaction) => transaction.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<List<Transaction>> getTransactions() async {
    return [..._transactions];
  }
  
  @override
  Future<Account> updateAccount(Account account) async {
    final index = _accounts.indexWhere((a) => a.id == account.id);
    if (index == -1) {
      throw Exception('Compte non trouvé: ${account.id}');
    }
    
    _accounts[index] = account;
    return account;
  }
  
  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index == -1) {
      throw Exception('Transaction non trouvée: ${transaction.id}');
    }
    
    final oldTransaction = _transactions[index];
    
    // Mettre à jour les soldes des comptes si nécessaire
    if (oldTransaction.accountId != null) {
      // Annuler l'effet de l'ancienne transaction
      _updateAccountBalance(
        oldTransaction.accountId!,
        oldTransaction.type == TransactionType.income 
            ? -oldTransaction.amount 
            : oldTransaction.amount,
      );
    }
    
    // Appliquer la nouvelle transaction
    if (transaction.accountId != null) {
      _updateAccountBalance(
        transaction.accountId!,
        transaction.type == TransactionType.income 
            ? transaction.amount 
            : -transaction.amount,
      );
    }
    
    _transactions[index] = transaction;
    return transaction;
  }
  
  /// Méthode utilitaire pour mettre à jour le solde d'un compte
  void _updateAccountBalance(String accountId, double amountChange) {
    final index = _accounts.indexWhere((a) => a.id == accountId);
    if (index != -1) {
      final account = _accounts[index];
      _accounts[index] = account.copyWith(
        balance: account.balance + amountChange,
        updatedAt: DateTime.now(),
      );
    }
  }
}
