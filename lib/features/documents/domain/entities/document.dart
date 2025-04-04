import 'package:flutter/material.dart';

/// Enum représentant les types de document
enum DocumentType {
  invoice,
  contract,
  proposal,
  report,
  letter,
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
      case DocumentType.letter:
        return 'Lettre';
      case DocumentType.other:
        return 'Autre';
    }
  }
  
  /// Couleur associée au type
  int get color {
    switch (this) {
      case DocumentType.invoice:
        return Colors.blue.value;
      case DocumentType.contract:
        return Colors.purple.value;
      case DocumentType.proposal:
        return Colors.orange.value;
      case DocumentType.report:
        return Colors.teal.value;
      case DocumentType.letter:
        return Colors.indigo.value;
      case DocumentType.other:
        return Colors.grey.value;
    }
  }
}

/// Enum représentant les statuts de document
enum DocumentStatus {
  draft,
  pending,
  approved,
  rejected,
  expired,
  completed;
  
  /// Nom d'affichage du statut
  String get displayName {
    switch (this) {
      case DocumentStatus.draft:
        return 'Brouillon';
      case DocumentStatus.pending:
        return 'En attente';
      case DocumentStatus.approved:
        return 'Approuvé';
      case DocumentStatus.rejected:
        return 'Rejeté';
      case DocumentStatus.expired:
        return 'Expiré';
      case DocumentStatus.completed:
        return 'Terminé';
    }
  }
  
  /// Couleur associée au statut
  int get color {
    switch (this) {
      case DocumentStatus.draft:
        return Colors.grey.value;
      case DocumentStatus.pending:
        return Colors.orange.value;
      case DocumentStatus.approved:
        return Colors.green.value;
      case DocumentStatus.rejected:
        return Colors.red.value;
      case DocumentStatus.expired:
        return Colors.redAccent.value;
      case DocumentStatus.completed:
        return Colors.blue.value;
    }
  }
}

/// Entité représentant un document
class Document {
  final String id;
  final String title;
  final DocumentType type;
  final DocumentStatus status;
  final String content;
  final String contentPreview;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? expiryDate;
  final String recipientName;
  final String recipientEmail;
  final String templateId;
  final Map<String, dynamic> data;
  
  /// Indique si le document a un destinataire
  bool get hasRecipient => recipientName.isNotEmpty || recipientEmail.isNotEmpty;
  
  /// Indique si le document est expiré
  bool get isExpired => expiryDate != null && expiryDate!.isBefore(DateTime.now());
  
  Document({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.content,
    this.contentPreview = '',
    required this.createdAt,
    this.updatedAt,
    this.expiryDate,
    this.recipientName = '',
    this.recipientEmail = '',
    required this.templateId,
    required this.data,
  });
  
  /// Copie le document avec de nouvelles valeurs
  Document copyWith({
    String? id,
    String? title,
    DocumentType? type,
    DocumentStatus? status,
    String? content,
    String? contentPreview,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expiryDate,
    String? recipientName,
    String? recipientEmail,
    String? templateId,
    Map<String, dynamic>? data,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      content: content ?? this.content,
      contentPreview: contentPreview ?? this.contentPreview,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiryDate: expiryDate ?? this.expiryDate,
      recipientName: recipientName ?? this.recipientName,
      recipientEmail: recipientEmail ?? this.recipientEmail,
      templateId: templateId ?? this.templateId,
      data: data ?? this.data,
    );
  }
}
