import 'package:equatable/equatable.dart';

enum TransactionType {
  income,
  expense,
}

class Transaction extends Equatable {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final String? clientId;

  const Transaction({
    required this.id,
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
    id, 
    title, 
    description, 
    amount, 
    date, 
    type, 
    category, 
    clientId,
  ];

  Transaction copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    DateTime? date,
    TransactionType? type,
    String? category,
    String? clientId,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
      clientId: clientId ?? this.clientId,
    );
  }
}

class Invoice extends Equatable {
  final String id;
  final String invoiceNumber;
  final String clientName;
  final double amount;
  final DateTime issueDate;
  final DateTime dueDate;
  final InvoiceStatus status;
  final List<InvoiceItem> items;

  const Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.clientName,
    required this.amount,
    required this.issueDate,
    required this.dueDate,
    required this.status,
    required this.items,
  });

  @override
  List<Object> get props => [
    id, 
    invoiceNumber, 
    clientName, 
    amount, 
    issueDate, 
    dueDate, 
    status, 
    items,
  ];

  Invoice copyWith({
    String? id,
    String? invoiceNumber,
    String? clientName,
    double? amount,
    DateTime? issueDate,
    DateTime? dueDate,
    InvoiceStatus? status,
    List<InvoiceItem>? items,
  }) {
    return Invoice(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      clientName: clientName ?? this.clientName,
      amount: amount ?? this.amount,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }
}

class InvoiceItem extends Equatable {
  final String id;
  final String description;
  final double quantity;
  final double unitPrice;
  final double? taxRate;

  const InvoiceItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.taxRate,
  });

  double get total => quantity * unitPrice;

  double get taxAmount => taxRate != null ? total * (taxRate! / 100) : 0;

  double get totalWithTax => total + taxAmount;

  @override
  List<Object?> get props => [id, description, quantity, unitPrice, taxRate];
}

enum InvoiceStatus {
  draft,
  sent,
  paid,
  overdue,
  cancelled,
}
