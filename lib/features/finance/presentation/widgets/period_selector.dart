import 'package:flutter/material.dart';
import '../../domain/entities/financial_summary.dart';

/// Widget permettant de sélectionner une période financière
class PeriodSelector extends StatelessWidget {
  final FinancialPeriod selectedPeriod;
  final Function(FinancialPeriod) onPeriodChanged;
  
  const PeriodSelector({
    Key? key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Période :',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildPeriodTabs(context),
          ],
        ),
      ),
    );
  }
  
  /// Construit les onglets de période
  Widget _buildPeriodTabs(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPeriodTab(
          context: context,
          period: FinancialPeriod.monthly,
          label: 'Mois',
        ),
        _buildPeriodTab(
          context: context,
          period: FinancialPeriod.quarterly,
          label: 'Trim.',
        ),
        _buildPeriodTab(
          context: context,
          period: FinancialPeriod.yearly,
          label: 'Année',
        ),
        _buildPeriodTab(
          context: context,
          period: FinancialPeriod.custom,
          label: 'Perso.',
          icon: Icons.date_range,
        ),
      ],
    );
  }
  
  /// Construit un onglet de période
  Widget _buildPeriodTab({
    required BuildContext context,
    required FinancialPeriod period,
    required String label,
    IconData? icon,
  }) {
    final isSelected = selectedPeriod == period;
    
    return GestureDetector(
      onTap: () => onPeriodChanged(period),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16.0,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
              const SizedBox(width: 4.0),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
