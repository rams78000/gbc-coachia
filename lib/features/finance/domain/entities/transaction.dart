import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum TransactionType {
  income,
  expense,
}

enum TransactionCategory {
  // Catégories de revenus
  salary,
  clientPayment,
  investment,
  sale,
  other,
  
  // Catégories de dépenses
  rent,
  utilities,
  equipment,
  software,
  marketing,
  travel,
  food,
  tax,
  insurance,
  subscription,
  miscellaneous,
}

class Transaction extends Equatable {
  final String id;
  final String title;
  final String description;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;
  final bool isRecurring;
  final RecurrencePattern? recurrencePattern;

  const Transaction({
    required this.id,
    required this.title,
    this.description = '',
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.isRecurring = false,
    this.recurrencePattern,
  });

  /// Crée une nouvelle transaction avec un ID généré automatiquement
  factory Transaction.create({
    required String title,
    String description = '',
    required double amount,
    required TransactionType type,
    required TransactionCategory category,
    DateTime? date,
    bool isRecurring = false,
    RecurrencePattern? recurrencePattern,
  }) {
    final uuid = const Uuid().v4();
    return Transaction(
      id: uuid,
      title: title,
      description: description,
      amount: amount,
      type: type,
      category: category,
      date: date ?? DateTime.now(),
      isRecurring: isRecurring,
      recurrencePattern: recurrencePattern,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        amount,
        type,
        category,
        date,
        isRecurring,
        recurrencePattern,
      ];

  Transaction copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
    bool? isRecurring,
    RecurrencePattern? recurrencePattern,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
    );
  }

  // Conversion depuis/vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'type': type.index,
      'category': category.index,
      'date': date.toIso8601String(),
      'isRecurring': isRecurring,
      'recurrencePattern': recurrencePattern?.toJson(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      amount: json['amount'] as double,
      type: TransactionType.values[json['type'] as int],
      category: TransactionCategory.values[json['category'] as int],
      date: DateTime.parse(json['date'] as String),
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurrencePattern: json['recurrencePattern'] != null
          ? RecurrencePattern.fromJson(
              json['recurrencePattern'] as Map<String, dynamic>)
          : null,
    );
  }
}

enum RecurrenceFrequency {
  daily,
  weekly,
  monthly,
  quarterly,
  annually,
}

class RecurrencePattern extends Equatable {
  final RecurrenceFrequency frequency;
  final int interval; // Ex: tous les 2 mois pour monthly et interval=2
  final DateTime startDate;
  final DateTime? endDate;
  final int? occurrences; // Nombre d'occurrences si pas de end date

  const RecurrencePattern({
    required this.frequency,
    this.interval = 1,
    required this.startDate,
    this.endDate,
    this.occurrences,
  });

  @override
  List<Object?> get props => [
        frequency,
        interval,
        startDate,
        endDate,
        occurrences,
      ];

  RecurrencePattern copyWith({
    RecurrenceFrequency? frequency,
    int? interval,
    DateTime? startDate,
    DateTime? endDate,
    int? occurrences,
  }) {
    return RecurrencePattern(
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      occurrences: occurrences ?? this.occurrences,
    );
  }

  // Conversion depuis/vers JSON
  Map<String, dynamic> toJson() {
    return {
      'frequency': frequency.index,
      'interval': interval,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'occurrences': occurrences,
    };
  }

  factory RecurrencePattern.fromJson(Map<String, dynamic> json) {
    return RecurrencePattern(
      frequency: RecurrenceFrequency.values[json['frequency'] as int],
      interval: json['interval'] as int? ?? 1,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      occurrences: json['occurrences'] as int?,
    );
  }
}
