import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';

/// Widget pour filtrer les documents par type ou statut
class DocumentFilter extends StatelessWidget {
  final bool isTypeFilter;
  final int? selectedIndex;
  final Function(int) onFilterSelected;

  const DocumentFilter({
    Key? key,
    required this.isTypeFilter,
    required this.selectedIndex,
    required this.onFilterSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final values = isTypeFilter ? DocumentType.values : DocumentStatus.values;
    
    return SizedBox(
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: values.length,
        itemBuilder: (context, index) {
          final label = isTypeFilter
              ? DocumentType.values[index].displayName
              : DocumentStatus.values[index].displayName;
          
          final color = isTypeFilter
              ? DocumentType.values[index].color
              : DocumentStatus.values[index].color;
          
          final isSelected = selectedIndex == index;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => onFilterSelected(index),
              backgroundColor: Color(color).withOpacity(0.1),
              selectedColor: Color(color).withOpacity(0.3),
              checkmarkColor: Color(color),
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected 
                    ? Color(color)
                    : theme.textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
              side: BorderSide(
                color: isSelected ? Color(color) : Colors.transparent,
                width: 1.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            ),
          );
        },
      ),
    );
  }
}
