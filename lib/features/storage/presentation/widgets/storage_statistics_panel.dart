import 'package:flutter/material.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_file.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_statistics.dart';

/// Widget pour afficher les statistiques de stockage
class StorageStatisticsPanel extends StatelessWidget {
  final StorageStatistics statistics;
  
  const StorageStatisticsPanel({
    Key? key,
    required this.statistics,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Utilisation du stockage',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16.0),
            
            // Barre de progression
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: LinearProgressIndicator(
                value: statistics.usagePercentage / 100,
                minHeight: 10.0,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getColorForUsage(statistics.usagePercentage),
                ),
              ),
            ),
            
            const SizedBox(height: 8.0),
            
            // Texte d'utilisation
            Text(
              '${statistics.formattedUsedSize} utilisé sur ${statistics.formattedTotalSize} (${statistics.usagePercentage.toStringAsFixed(1)}%)',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 24.0),
            
            // Statistiques par type de fichier
            const Text(
              'Répartition par type',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16.0),
            
            // Liste des types de fichiers
            ...FileType.values.map((type) {
              final count = statistics.fileTypeCount[type] ?? 0;
              final size = statistics.fileTypeSize[type] ?? 0;
              
              if (count <= 0) {
                return const SizedBox.shrink();
              }
              
              // Formatter la taille
              String formattedSize;
              if (size < 1024) {
                formattedSize = '$size o';
              } else if (size < 1024 * 1024) {
                formattedSize = '${(size / 1024).toStringAsFixed(1)} Ko';
              } else if (size < 1024 * 1024 * 1024) {
                formattedSize = '${(size / (1024 * 1024)).toStringAsFixed(1)} Mo';
              } else {
                formattedSize = '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} Go';
              }
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: type.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Icon(
                        type.icon,
                        color: type.color,
                        size: 16,
                      ),
                    ),
                    
                    const SizedBox(width: 12.0),
                    
                    // Nom du type
                    Expanded(
                      child: Text(
                        type.displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                    // Nombre de fichiers
                    Text(
                      '$count fichier${count > 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.0,
                      ),
                    ),
                    
                    const SizedBox(width: 8.0),
                    
                    // Taille totale
                    Text(
                      formattedSize,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).where((widget) => widget is! SizedBox).toList(),
            
            const SizedBox(height: 16.0),
            
            // Nombre total de fichiers et dossiers
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    Icons.description,
                    statistics.totalFiles.toString(),
                    'Fichiers',
                  ),
                  _buildStatItem(
                    context,
                    Icons.folder,
                    statistics.totalFolders.toString(),
                    'Dossiers',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24.0,
        ),
        const SizedBox(height: 8.0),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
  
  Color _getColorForUsage(double percentage) {
    if (percentage < 50) {
      return Colors.green;
    } else if (percentage < 75) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
