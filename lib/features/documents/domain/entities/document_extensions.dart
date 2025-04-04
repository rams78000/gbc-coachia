import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:intl/intl.dart';

/// Extensions pour les entités Document
extension DocumentExtensions on Document {
  /// Retourne la date de création formatée
  String get formattedCreatedAt {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(createdAt);
  }
  
  /// Retourne la date de mise à jour formatée
  String? get formattedUpdatedAt {
    if (updatedAt == null) return null;
    
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(updatedAt!);
  }
  
  /// Retourne la date d'expiration formatée
  String? get formattedExpiryDate {
    if (expiryDate == null) return null;
    
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(expiryDate!);
  }
}
