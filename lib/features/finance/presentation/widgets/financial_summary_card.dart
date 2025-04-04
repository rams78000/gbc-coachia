import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/financial_summary.dart';

/// Widget affichant un résumé financier sous forme de carte
class FinancialSummaryCard extends StatelessWidget {
  final FinancialSummary summary;
  final VoidCallback? onTap;
  
  const FinancialSummaryCard({
    Key? key,
    required this.summary,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Format des montants
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: '€',
      decimalDigits: 2,
    );
    
    // Format de date
    final dateFormat = DateFormat.yMMMM('fr_FR');
    
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre avec période
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Résumé financier',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    dateFormat.format(summary.startDate),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
              
              const Divider(height: 24.0),
              
              // Statistiques principales
              Row(
                children: [
                  // Revenus
                  Expanded(
                    child: _buildStatItem(
                      context,
                      title: 'Revenus',
                      amount: summary.totalIncome,
                      icon: Icons.trending_up,
                      color: Colors.green,
                      currencyFormat: currencyFormat,
                    ),
                  ),
                  
                  // Dépenses
                  Expanded(
                    child: _buildStatItem(
                      context,
                      title: 'Dépenses',
                      amount: summary.totalExpenses,
                      icon: Icons.trending_down,
                      color: Colors.red,
                      currencyFormat: currencyFormat,
                    ),
                  ),
                  
                  // Solde
                  Expanded(
                    child: _buildStatItem(
                      context,
                      title: 'Solde',
                      amount: summary.netBalance,
                      icon: Icons.account_balance_wallet,
                      color: summary.netBalance >= 0 ? Colors.blue : Colors.orange,
                      currencyFormat: currencyFormat,
                    ),
                  ),
                ],
              ),
              
              // Budget (si disponible)
              if (summary.budgetAvailable != null && summary.budgetUsedPercentage != null) ...[
                const SizedBox(height: 16.0),
                
                // Titre budget
                Text(
                  'Budget',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                
                const SizedBox(height: 8.0),
                
                // Progression du budget
                LinearProgressIndicator(
                  value: summary.budgetUsedPercentage! / 100,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    summary.budgetUsedPercentage! > 100 ? Colors.red : Colors.green,
                  ),
                ),
                
                const SizedBox(height: 8.0),
                
                // Détails du budget
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Utilisé: ${summary.budgetUsedPercentage!.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Disponible: ${currencyFormat.format(summary.budgetAvailable)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: summary.budgetAvailable! < 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
              
              // Nombre de transactions
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 16.0,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${summary.transactionCount} transaction${summary.transactionCount > 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Construit un élément statistique avec titre, montant et icône
  Widget _buildStatItem(
    BuildContext context, {
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
    required NumberFormat currencyFormat,
  }) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4.0),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4.0),
        Text(
          currencyFormat.format(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
