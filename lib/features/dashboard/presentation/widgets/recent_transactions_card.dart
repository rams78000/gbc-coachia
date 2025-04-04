import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/finance/domain/models/transaction.dart';
import 'package:intl/intl.dart';

class RecentTransactionsCard extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback onTap;

  const RecentTransactionsCard({
    Key? key,
    required this.transactions,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.receipt_long,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Transactions récentes',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            
            // Transactions List
            SizedBox(
              height: 250,
              child: transactions.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return _buildTransactionItem(context, transactions[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune transaction récente',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vos dernières transactions apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMM', 'fr_FR');
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    
    final isIncome = transaction.isIncome;
    final amountColor = isIncome ? Colors.green[700] : Colors.red[700];
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Category icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getCategoryColor(transaction.category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(transaction.category),
              color: _getCategoryColor(transaction.category),
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        transaction.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${isIncome ? '+' : '-'} ${currencyFormat.format(transaction.amount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: amountColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.category,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          transaction.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(transaction.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (transaction.isPending)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'En attente',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.amber[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final lowerCategory = category.toLowerCase();
    
    if (lowerCategory.contains('salaire') || 
        lowerCategory.contains('revenu') ||
        lowerCategory.contains('vente') ||
        lowerCategory.contains('freelance')) {
      return Colors.green;
    } else if (lowerCategory.contains('client') || 
               lowerCategory.contains('facture')) {
      return Colors.blue;
    } else if (lowerCategory.contains('impôt') || 
               lowerCategory.contains('impot') ||
               lowerCategory.contains('taxe')) {
      return Colors.red;
    } else if (lowerCategory.contains('alimentation') || 
               lowerCategory.contains('nourriture') ||
               lowerCategory.contains('restaurant')) {
      return Colors.orange;
    } else if (lowerCategory.contains('transport') || 
               lowerCategory.contains('essence') ||
               lowerCategory.contains('carburant')) {
      return Colors.deepPurple;
    } else if (lowerCategory.contains('logement') || 
               lowerCategory.contains('loyer') ||
               lowerCategory.contains('hypothèque') ||
               lowerCategory.contains('hypotheque')) {
      return Colors.brown;
    } else if (lowerCategory.contains('loisir') || 
               lowerCategory.contains('divertissement')) {
      return Colors.pink;
    } else if (lowerCategory.contains('santé') || 
               lowerCategory.contains('sante') ||
               lowerCategory.contains('médical') ||
               lowerCategory.contains('medical')) {
      return Colors.teal;
    } else {
      return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    final lowerCategory = category.toLowerCase();
    
    if (lowerCategory.contains('salaire') || 
        lowerCategory.contains('revenu') ||
        lowerCategory.contains('vente') ||
        lowerCategory.contains('freelance')) {
      return Icons.payments;
    } else if (lowerCategory.contains('client') || 
               lowerCategory.contains('facture')) {
      return Icons.receipt;
    } else if (lowerCategory.contains('impôt') || 
               lowerCategory.contains('impot') ||
               lowerCategory.contains('taxe')) {
      return Icons.account_balance;
    } else if (lowerCategory.contains('alimentation') || 
               lowerCategory.contains('nourriture') ||
               lowerCategory.contains('restaurant')) {
      return Icons.restaurant;
    } else if (lowerCategory.contains('transport') || 
               lowerCategory.contains('essence') ||
               lowerCategory.contains('carburant')) {
      return Icons.directions_car;
    } else if (lowerCategory.contains('logement') || 
               lowerCategory.contains('loyer') ||
               lowerCategory.contains('hypothèque') ||
               lowerCategory.contains('hypotheque')) {
      return Icons.home;
    } else if (lowerCategory.contains('loisir') || 
               lowerCategory.contains('divertissement')) {
      return Icons.movie;
    } else if (lowerCategory.contains('santé') || 
               lowerCategory.contains('sante') ||
               lowerCategory.contains('médical') ||
               lowerCategory.contains('medical')) {
      return Icons.local_hospital;
    } else {
      return Icons.category;
    }
  }
}
