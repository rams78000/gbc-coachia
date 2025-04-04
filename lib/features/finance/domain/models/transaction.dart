import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// Modèle pour représenter une transaction financière (revenus ou dépenses)
class Transaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String? description;
  final bool isIncome;
  final bool isPending;
  final String? paymentMethod;
  final String? documentId; // Lien vers un document associé (facture, reçu, etc.)
  final Map<String, dynamic>? metadata;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.description,
    required this.isIncome,
    this.isPending = false,
    this.paymentMethod,
    this.documentId,
    this.metadata,
  });

  /// Crée une transaction avec un ID généré
  factory Transaction.create({
    required String title,
    required double amount,
    required DateTime date,
    required String category,
    String? description,
    required bool isIncome,
    bool isPending = false,
    String? paymentMethod,
    String? documentId,
    Map<String, dynamic>? metadata,
  }) {
    return Transaction(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      date: date,
      category: category,
      description: description,
      isIncome: isIncome,
      isPending: isPending,
      paymentMethod: paymentMethod,
      documentId: documentId,
      metadata: metadata,
    );
  }

  /// Crée une copie modifiée de cette transaction
  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    String? category,
    String? description,
    bool? isIncome,
    bool? isPending,
    String? paymentMethod,
    String? documentId,
    Map<String, dynamic>? metadata,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      description: description ?? this.description,
      isIncome: isIncome ?? this.isIncome,
      isPending: isPending ?? this.isPending,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      documentId: documentId ?? this.documentId,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        date,
        category,
        description,
        isIncome,
        isPending,
        paymentMethod,
        documentId,
        metadata,
      ];

  /// Convertit cette transaction en Map pour stocker dans la base de données ou JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
      'isIncome': isIncome,
      'isPending': isPending,
      'paymentMethod': paymentMethod,
      'documentId': documentId,
      'metadata': metadata,
    };
  }

  /// Crée une transaction à partir d'une Map ou JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
      description: json['description'] as String?,
      isIncome: json['isIncome'] as bool,
      isPending: json['isPending'] as bool? ?? false,
      paymentMethod: json['paymentMethod'] as String?,
      documentId: json['documentId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}
