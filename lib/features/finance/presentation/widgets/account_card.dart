import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/account.dart';

/// Widget représentant une carte de compte financier
class AccountCard extends StatelessWidget {
  final Account account;
  final VoidCallback? onTap;
  final VoidCallback? onEditTap;
  
  const AccountCard({
    Key? key,
    required this.account,
    this.onTap,
    this.onEditTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Format du montant
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: account.currency == 'EUR' ? '€' : account.currency,
      decimalDigits: 2,
    );
    
    // Format de la date de mise à jour
    final dateFormat = DateFormat.yMMMd('fr_FR').add_Hm();
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre et bouton d'édition
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getAccountTypeIcon(),
                        color: _getAccountTypeColor(context),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        account.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (onEditTap != null)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: onEditTap,
                      tooltip: 'Modifier',
                      iconSize: 18,
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                    ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Institution
              if (account.institution.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      account.institution,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              
              // Type de compte
              Row(
                children: [
                  Icon(
                    Icons.account_balance_outlined,
                    size: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    account.type.getLocalizedName(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Solde
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Solde actuel',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    currencyFormat.format(account.balance),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: account.balance >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              
              // Solde initial
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Solde initial',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    currencyFormat.format(account.initialBalance),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Date de mise à jour
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.update,
                    size: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Màj: ${dateFormat.format(account.updatedAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Renvoie l'icône correspondant au type de compte
  IconData _getAccountTypeIcon() {
    switch (account.type) {
      case AccountType.checking:
        return Icons.account_balance_wallet_outlined;
      case AccountType.savings:
        return Icons.savings_outlined;
      case AccountType.creditCard:
        return Icons.credit_card_outlined;
      case AccountType.investment:
        return Icons.trending_up_outlined;
      case AccountType.loan:
        return Icons.money_outlined;
      case AccountType.cash:
        return Icons.payments_outlined;
      default:
        return Icons.account_balance_outlined;
    }
  }
  
  /// Renvoie la couleur correspondant au type de compte
  Color _getAccountTypeColor(BuildContext context) {
    switch (account.type) {
      case AccountType.checking:
        return Colors.blue;
      case AccountType.savings:
        return Colors.purple;
      case AccountType.creditCard:
        return Colors.orange;
      case AccountType.investment:
        return Colors.green;
      case AccountType.loan:
        return Colors.red;
      case AccountType.cash:
        return Colors.teal;
      default:
        return Theme.of(context).primaryColor;
    }
  }
}
