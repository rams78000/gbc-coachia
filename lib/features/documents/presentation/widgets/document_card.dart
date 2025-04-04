import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:intl/intl.dart';

/// Widget pour afficher un document sous forme de carte
class DocumentCard extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  
  const DocumentCard({
    Key? key,
    required this.document,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(document.createdAt);
    
    // Formater le montant s'il existe
    String? formattedAmount;
    if (document.amount != null && document.currency != null) {
      final numberFormat = NumberFormat.currency(
        symbol: _getCurrencySymbol(document.currency!),
        decimalDigits: 2,
      );
      formattedAmount = numberFormat.format(document.amount);
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec type et statut
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: document.type.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          document.type.icon,
                          size: 16.0,
                          color: document.type.color,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          document.type.displayName,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: document.type.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 8.0),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: document.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          document.status.icon,
                          size: 16.0,
                          color: document.status.color,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          document.status.displayName,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: document.status.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Menu d'options
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20.0),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Modifier'),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Supprimer'),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16.0),
              
              // Titre du document
              Text(
                document.title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8.0),
              
              // Informations complémentaires
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Client
                  if (document.clientName != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              document.clientName!,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[700],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Montant
                  if (formattedAmount != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            formattedAmount,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Date de création
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16.0,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          'Créé le $formattedDate',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Date d'expiration
                  if (document.expiresAt != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.timelapse,
                          size: 16.0,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          'Expire le ${dateFormat.format(document.expiresAt!)}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: _isExpired(document.expiresAt!) ? Colors.red : Colors.grey[700],
                            fontWeight: _isExpired(document.expiresAt!) ? FontWeight.bold : null,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Vérifie si une date est expirée
  bool _isExpired(DateTime date) {
    return date.isBefore(DateTime.now());
  }
  
  // Obtient le symbole de la devise
  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'EUR':
        return '€';
      case 'USD':
        return '\$';
      case 'GBP':
        return '£';
      case 'CAD':
        return 'CA\$';
      default:
        return currency;
    }
  }
}
