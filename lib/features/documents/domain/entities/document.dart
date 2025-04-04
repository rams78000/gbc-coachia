import 'package:flutter/material.dart';

/// Enum pour le type de document
enum DocumentType {
  invoice,
  contract,
  proposal,
  report,
  other;
  
  /// Nom d'affichage du type
  String get displayName {
    switch (this) {
      case DocumentType.invoice:
        return 'Facture';
      case DocumentType.contract:
        return 'Contrat';
      case DocumentType.proposal:
        return 'Proposition';
      case DocumentType.report:
        return 'Rapport';
      case DocumentType.other:
        return 'Autre';
    }
  }
  
  /// Couleur associée au type
  Color get color {
    switch (this) {
      case DocumentType.invoice:
        return Colors.green;
      case DocumentType.contract:
        return Colors.blue;
      case DocumentType.proposal:
        return Colors.purple;
      case DocumentType.report:
        return Colors.orange;
      case DocumentType.other:
        return Colors.grey;
    }
  }
  
  /// Icône associée au type
  IconData get icon {
    switch (this) {
      case DocumentType.invoice:
        return Icons.receipt;
      case DocumentType.contract:
        return Icons.assignment;
      case DocumentType.proposal:
        return Icons.description;
      case DocumentType.report:
        return Icons.summarize;
      case DocumentType.other:
        return Icons.article;
    }
  }
}

/// Enum pour le statut d'un document
enum DocumentStatus {
  draft,
  sent,
  signed,
  paid,
  rejected,
  expired,
  archived;
  
  /// Nom d'affichage du statut
  String get displayName {
    switch (this) {
      case DocumentStatus.draft:
        return 'Brouillon';
      case DocumentStatus.sent:
        return 'Envoyé';
      case DocumentStatus.signed:
        return 'Signé';
      case DocumentStatus.paid:
        return 'Payé';
      case DocumentStatus.rejected:
        return 'Rejeté';
      case DocumentStatus.expired:
        return 'Expiré';
      case DocumentStatus.archived:
        return 'Archivé';
    }
  }
  
  /// Couleur associée au statut
  Color get color {
    switch (this) {
      case DocumentStatus.draft:
        return Colors.grey;
      case DocumentStatus.sent:
        return Colors.blue;
      case DocumentStatus.signed:
        return Colors.green;
      case DocumentStatus.paid:
        return Colors.purple;
      case DocumentStatus.rejected:
        return Colors.red;
      case DocumentStatus.expired:
        return Colors.orange;
      case DocumentStatus.archived:
        return Colors.brown;
    }
  }
  
  /// Icône associée au statut
  IconData get icon {
    switch (this) {
      case DocumentStatus.draft:
        return Icons.edit;
      case DocumentStatus.sent:
        return Icons.send;
      case DocumentStatus.signed:
        return Icons.check_circle;
      case DocumentStatus.paid:
        return Icons.paid;
      case DocumentStatus.rejected:
        return Icons.cancel;
      case DocumentStatus.expired:
        return Icons.timer_off;
      case DocumentStatus.archived:
        return Icons.archive;
    }
  }
}

/// Entité représentant un document
class Document {
  final String id;
  final String title;
  final DocumentType type;
  final DocumentStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? expiresAt;
  final String? templateId;
  final Map<String, dynamic> data;
  final String content;
  final String? clientName;
  final String? clientEmail;
  final double? amount;
  final String? currency;
  final String? notes;
  final List<String>? tags;
  
  Document({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.expiresAt,
    this.templateId,
    required this.data,
    required this.content,
    this.clientName,
    this.clientEmail,
    this.amount,
    this.currency,
    this.notes,
    this.tags,
  });
  
  /// Copie le document avec de nouvelles valeurs
  Document copyWith({
    String? id,
    String? title,
    DocumentType? type,
    DocumentStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expiresAt,
    String? templateId,
    Map<String, dynamic>? data,
    String? content,
    String? clientName,
    String? clientEmail,
    double? amount,
    String? currency,
    String? notes,
    List<String>? tags,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      templateId: templateId ?? this.templateId,
      data: data ?? this.data,
      content: content ?? this.content,
      clientName: clientName ?? this.clientName,
      clientEmail: clientEmail ?? this.clientEmail,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
    );
  }
}
