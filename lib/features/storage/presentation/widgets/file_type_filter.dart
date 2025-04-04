import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_file.dart';

/// Widget pour filtrer les fichiers par type
class FileTypeFilter extends StatelessWidget {
  final FileType? selectedType;
  final Function(FileType?) onTypeSelected;
  
  const FileTypeFilter({
    Key? key,
    this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          // Option "Tous"
          _buildFilterOption(
            context,
            null,
            'Tous',
            Icons.folder,
            Colors.grey,
          ),
          
          // Options pour chaque type de fichier
          ...FileType.values.map((type) {
            return _buildFilterOption(
              context,
              type,
              type.displayName,
              type.icon,
              type.color,
            );
          }).toList(),
        ],
      ),
    );
  }
  
  Widget _buildFilterOption(
    BuildContext context,
    FileType? type,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = (selectedType == null && type == null) ||
                      (selectedType == type);
    
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: () => onTypeSelected(type),
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: isSelected
                    ? Border.all(color: color, width: 2.0)
                    : null,
              ),
              child: Icon(
                icon,
                color: isSelected ? color : Colors.grey,
                size: 24.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
