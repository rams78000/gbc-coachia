import 'package:equatable/equatable.dart';

/// Interface pour le repository des finances
abstract class FinanceRepository {
  /// Récupère toutes les transactions
  Future<List<Transaction>> getTransactions();

  /// Ajoute une nouvelle transaction
  Future<void> addTransaction(Transaction transaction);

  /// Met à jour une transaction existante
  Future<void> updateTransaction(Transaction transaction);

  /// Supprime une transaction
  Future<void> deleteTransaction(String id);

  /// Obtient le solde actuel
  Future<double> getCurrentBalance();

  /// Obtient les statistiques financières pour la période donnée
  Future<FinanceStats> getStats(Period period);
}

/// Type d'une transaction
enum TransactionType {
  /// Revenu
  income,

  /// Dépense
  expense,
}

/// Enum pour les périodes d'analyse
enum Period {
  /// Semaine
  week,

  /// Mois
  month,

  /// Année
  year,
}

/// Modèle pour représenter une transaction financière
class Transaction extends Equatable {
  /// Identifiant unique de la transaction
  final String id;

  /// Description de la transaction
  final String description;

  /// Montant de la transaction
  final double amount;

  /// Date de la transaction
  final DateTime date;

  /// Type de transaction (revenu ou dépense)
  final TransactionType type;

  /// Catégorie de la transaction
  final String category;

  /// Constructeur
  const Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
  });

  @override
  List<Object> get props => [id, description, amount, date, type, category];

  /// Crée une copie de cette transaction avec les valeurs données
  Transaction copyWith({
    String? id,
    String? description,
    double? amount,
    DateTime? date,
    TransactionType? type,
    String? category,
  }) {
    return Transaction(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
    );
  }

  /// Convertit l'objet en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.toString(),
      'category': category,
    };
  }

  /// Crée un objet à partir d'une Map
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      description: map['description'] as String,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String),
      type: map['type'] == 'TransactionType.income'
          ? TransactionType.income
          : TransactionType.expense,
      category: map['category'] as String,
    );
  }
}

/// Modèle pour les statistiques financières
class FinanceStats extends Equatable {
  /// Total des revenus
  final double totalIncome;

  /// Total des dépenses
  final double totalExpenses;

  /// Solde net (revenus - dépenses)
  final double netBalance;

  /// Catégories de dépenses avec leurs montants
  final Map<String, double> expensesByCategory;

  /// Série chronologique des dépenses
  final List<DataPoint> expenseTrend;

  /// Série chronologique des revenus
  final List<DataPoint> incomeTrend;

  /// Constructeur
  const FinanceStats({
    required this.totalIncome,
    required this.totalExpenses,
    required this.netBalance,
    required this.expensesByCategory,
    required this.expenseTrend,
    required this.incomeTrend,
  });

  @override
  List<Object> get props => [
        totalIncome,
        totalExpenses,
        netBalance,
        expensesByCategory,
        expenseTrend,
        incomeTrend,
      ];
}

/// Point de données pour les graphiques
class DataPoint extends Equatable {
  /// Date du point
  final DateTime date;

  /// Valeur du point
  final double value;

  /// Constructeur
  const DataPoint({
    required this.date,
    required this.value,
  });

  @override
  List<Object> get props => [date, value];
}
