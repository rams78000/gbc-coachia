import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_folder.dart';

/// Widget pour afficher le chemin de navigation (breadcrumb)
class StoragePathNavigator extends StatelessWidget {
  final List<StorageFolder> path;
  final Function(String) onFolderTap;
  
  const StoragePathNavigator({
    Key? key,
    required this.path,
    required this.onFolderTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      color: Theme.of(context).colorScheme.surface,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: path.length,
        separatorBuilder: (context, index) => const Icon(
          Icons.chevron_right,
          size: 16.0,
          color: Colors.grey,
        ),
        itemBuilder: (context, index) {
          final folder = path[index];
          final isLast = index == path.length - 1;
          
          return Center(
            child: InkWell(
              onTap: isLast ? null : () => onFolderTap(folder.id),
              borderRadius: BorderRadius.circular(4.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: Text(
                  folder.name,
                  style: TextStyle(
                    fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                    color: isLast
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
