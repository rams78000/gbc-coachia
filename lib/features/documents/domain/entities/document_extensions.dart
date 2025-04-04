import 'package:intl/intl.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';

/// Extensions utiles pour la classe Document
extension DocumentExtensions on Document {
  /// Retourne une représentation formatée de la date de création
  String get formattedCreatedAt {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(createdAt);
  }
  
  /// Retourne une représentation formatée de la date de modification
  String? get formattedUpdatedAt {
    if (updatedAt == null) return null;
    
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(updatedAt!);
  }
  
  /// Retourne une représentation formatée de la date d'expiration
  String? get formattedExpiryDate {
    if (expiryDate == null) return null;
    
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(expiryDate!);
  }
  
  /// Retourne true si le document est expiré
  bool get isExpired {
    if (expiryDate == null) return false;
    
    return expiryDate!.isBefore(DateTime.now());
  }
  
  /// Retourne une chaîne courte pour l'aperçu du contenu
  String get contentPreview {
    if (content.isEmpty) return '';
    
    final maxLength = 100;
    if (content.length <= maxLength) return content;
    
    return '${content.substring(0, maxLength)}...';
  }
  
  /// Retourne la première lettre du titre
  String get initialLetter {
    if (title.isEmpty) return '?';
    
    return title[0].toUpperCase();
  }
  
  /// Retourne true si le document a un destinataire
  bool get hasRecipient {
    return recipientEmail != null && recipientEmail!.isNotEmpty;
  }
  
  /// Retourne l'icône associée au type de document
  String get typeIcon {
    switch (type) {
      case DocumentType.invoice:
        return 'assets/icons/invoice.svg';
      case DocumentType.proposal:
        return 'assets/icons/proposal.svg';
      case DocumentType.contract:
        return 'assets/icons/contract.svg';
      case DocumentType.report:
        return 'assets/icons/report.svg';
      case DocumentType.other:
        return 'assets/icons/document.svg';
    }
  }
  
  /// Retourne l'icône associée au statut du document
  String get statusIcon {
    switch (status) {
      case DocumentStatus.draft:
        return 'assets/icons/draft.svg';
      case DocumentStatus.sent:
        return 'assets/icons/sent.svg';
      case DocumentStatus.signed:
        return 'assets/icons/signed.svg';
      case DocumentStatus.expired:
        return 'assets/icons/expired.svg';
      case DocumentStatus.archived:
        return 'assets/icons/archived.svg';
    }
  }
}
