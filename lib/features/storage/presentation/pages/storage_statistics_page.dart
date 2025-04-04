import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_file.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_statistics.dart';
import 'package:gbc_coachia/features/storage/presentation/bloc/storage_bloc.dart';

/// Page affichant les statistiques détaillées du stockage
class StorageStatisticsPage extends StatefulWidget {
  const StorageStatisticsPage({Key? key}) : super(key: key);

  @override
  State<StorageStatisticsPage> createState() => _StorageStatisticsPageState();
}

class _StorageStatisticsPageState extends State<StorageStatisticsPage> {
  @override
  void initState() {
    super.initState();
    context.read<StorageBloc>().add(LoadStorageStatistics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques de stockage'),
        actions: [
          // Bouton de rafraîchissement
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<StorageBloc>().add(LoadStorageStatistics());
            },
          ),
        ],
      ),
      body: BlocBuilder<StorageBloc, StorageState>(
        builder: (context, state) {
          if (state is StorageStatisticsLoaded) {
            return _buildStatisticsContent(context, state.statistics);
          }
          
          if (state is StorageLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is StorageError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48.0,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Erreur: ${state.message}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<StorageBloc>().add(LoadStorageStatistics());
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          
          return const Center(child: Text('Chargement des statistiques...'));
        },
      ),
    );
  }
  
  // Construit le contenu principal des statistiques
  Widget _buildStatisticsContent(BuildContext context, StorageStatistics statistics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carte d'utilisation du stockage
          _buildStorageUsageCard(context, statistics),
          
          const SizedBox(height: 16.0),
          
          // Carte des types de fichiers
          _buildFileTypesCard(context, statistics),
          
          const SizedBox(height: 16.0),
          
          // Carte des statistiques générales
          _buildGeneralStatsCard(context, statistics),
        ],
      ),
    );
  }
  
  // Construit la carte d'utilisation du stockage
  Widget _buildStorageUsageCard(BuildContext context, StorageStatistics statistics) {
    return Card(
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
            
            const SizedBox(height: 24.0),
            
            // Graphique en anneau
            Center(
              child: SizedBox(
                width: 200.0,
                height: 200.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Cercle de progression
                    CircularProgressIndicator(
                      value: statistics.usagePercentage / 100,
                      strokeWidth: 12.0,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getColorForUsage(statistics.usagePercentage),
                      ),
                    ),
                    
                    // Texte au centre
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${statistics.usagePercentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'utilisé',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24.0),
            
            // Détails de l'utilisation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStorageDetail(
                  context,
                  'Utilisé',
                  statistics.formattedUsedSize,
                  _getColorForUsage(statistics.usagePercentage),
                ),
                
                _buildStorageDetail(
                  context,
                  'Disponible',
                  statistics.formattedTotalSize,
                  Colors.grey[600]!,
                ),
              ],
            ),
            
            const SizedBox(height: 16.0),
            
            // Bouton pour libérer de l'espace
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implémenter la libération d'espace
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Libération d\'espace non implémentée'),
                    ),
                  );
                },
                icon: const Icon(Icons.cleaning_services),
                label: const Text('Libérer de l\'espace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Construit la carte des types de fichiers
  Widget _buildFileTypesCard(BuildContext context, StorageStatistics statistics) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Répartition par type de fichier',
              style: TextStyle(
                fontSize: 18.0,
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
              
              // Calculer le pourcentage d'utilisation
              final percentage = size / statistics.usedSize * 100;
              
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
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                        
                        // Nom du type et statistiques
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    type.displayName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$formattedSize (${percentage.toStringAsFixed(1)}%)',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '$count fichier${count > 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8.0),
                    
                    // Barre de progression
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2.0),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        minHeight: 4.0,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(type.color),
                      ),
                    ),
                  ],
                ),
              );
            }).where((widget) => widget is! SizedBox).toList(),
            
            const SizedBox(height: 16.0),
            
            // Légende
            Center(
              child: Wrap(
                spacing: 16.0,
                runSpacing: 8.0,
                children: FileType.values.map((type) {
                  final count = statistics.fileTypeCount[type] ?? 0;
                  
                  if (count <= 0) {
                    return const SizedBox.shrink();
                  }
                  
                  return Chip(
                    avatar: Container(
                      decoration: BoxDecoration(
                        color: type.color,
                        shape: BoxShape.circle,
                      ),
                      width: 12.0,
                      height: 12.0,
                    ),
                    label: Text(type.displayName),
                    backgroundColor: Colors.grey[100],
                    visualDensity: VisualDensity.compact,
                  );
                }).where((widget) => widget is! SizedBox).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Construit la carte des statistiques générales
  Widget _buildGeneralStatsCard(BuildContext context, StorageStatistics statistics) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistiques générales',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16.0),
            
            // Grille de statistiques
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                _buildStatCard(
                  context,
                  'Fichiers',
                  statistics.totalFiles.toString(),
                  Icons.description,
                  Colors.blue,
                ),
                
                _buildStatCard(
                  context,
                  'Dossiers',
                  statistics.totalFolders.toString(),
                  Icons.folder,
                  Colors.amber,
                ),
                
                _buildStatCard(
                  context,
                  'Taille moyenne',
                  statistics.totalFiles > 0
                      ? _formatFileSize(statistics.usedSize ~/ statistics.totalFiles)
                      : '0 o',
                  Icons.data_usage,
                  Colors.green,
                ),
                
                _buildStatCard(
                  context,
                  'Occupation',
                  '${statistics.usagePercentage.toStringAsFixed(1)}%',
                  Icons.storage,
                  _getColorForUsage(statistics.usagePercentage),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // Construit un détail d'utilisation du stockage
  Widget _buildStorageDetail(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: color,
          ),
        ),
      ],
    );
  }
  
  // Construit une carte de statistique
  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 32.0,
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: color,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
  
  // Obtient la couleur en fonction du pourcentage d'utilisation
  Color _getColorForUsage(double percentage) {
    if (percentage < 50) {
      return Colors.green;
    } else if (percentage < 75) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
  
  // Formate la taille d'un fichier
  String _formatFileSize(int size) {
    if (size < 1024) {
      return '$size o';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)} Ko';
    } else if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} Mo';
    } else {
      return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} Go';
    }
  }
}
