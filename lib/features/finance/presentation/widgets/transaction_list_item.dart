import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/transaction.dart';

/// Widget représentant un élément dans la liste des transactions
class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  
  const TransactionListItem({
    Key? key,
    required this.transaction,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Format de la date
    final dateFormat = DateFormat.yMMMd('fr_FR');
    
    // Format du montant
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: '€',
      decimalDigits: 2,
    );
    
    // Couleur du montant (rouge pour dépense, vert pour revenu)
    final amountColor = transaction.type == TransactionType.income
        ? Colors.green
        : Colors.red;
    
    // Préfixe du montant
    final amountPrefix = transaction.type == TransactionType.income ? '+' : '-';
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Icône de catégorie
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: transaction.category.getColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  transaction.category.getIcon(),
                  color: transaction.category.getColor(),
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Détails de la transaction
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(transaction.date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: transaction.category.getColor().withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            transaction.category.getLocalizedName(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: transaction.category.getColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Montant
              Text(
                '$amountPrefix${currencyFormat.format(transaction.amount)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
