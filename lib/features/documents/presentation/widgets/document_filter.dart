import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';

/// Widget pour filtrer les documents par type ou statut
class DocumentFilter extends StatelessWidget {
  final bool isTypeFilter; // true pour filtrer par type, false pour filtrer par statut
  final int? selectedIndex; // Index du filtre sélectionné
  final Function(int) onFilterSelected; // Callback lorsqu'un filtre est sélectionné
  
  const DocumentFilter({
    Key? key,
    required this.isTypeFilter,
    this.selectedIndex,
    required this.onFilterSelected,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // La liste des filtres dépend du type de filtre
    final List<_FilterItem> filterItems = isTypeFilter
        ? DocumentType.values.map((type) => _FilterItem(
            label: type.displayName,
            color: type.color,
            icon: type.icon,
          )).toList()
        : DocumentStatus.values.map((status) => _FilterItem(
            label: status.displayName,
            color: status.color,
            icon: status.icon,
          )).toList();
    
    return SizedBox(
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: filterItems.length,
        itemBuilder: (context, index) {
          final item = filterItems[index];
          final isSelected = selectedIndex == index;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(item.label),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : item.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              avatar: Icon(
                item.icon,
                size: 16.0,
                color: isSelected ? Colors.white : item.color,
              ),
              backgroundColor: item.color.withOpacity(0.1),
              selectedColor: item.color,
              selected: isSelected,
              onSelected: (selected) {
                onFilterSelected(index);
              },
            ),
          );
        },
      ),
    );
  }
}

/// Classe pour les éléments de filtre
class _FilterItem {
  final String label;
  final Color color;
  final IconData icon;
  
  _FilterItem({
    required this.label,
    required this.color,
    required this.icon,
  });
}
