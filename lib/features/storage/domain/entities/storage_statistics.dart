import 'package:gbc_coachia/features/storage/domain/entities/storage_file.dart';

/// Entité représentant les statistiques de stockage
class StorageStatistics {
  final int totalSize;
  final int usedSize;
  final int availableSize;
  final int totalFiles;
  final int totalFolders;
  final Map<FileType, int> fileTypeCount;
  final Map<FileType, int> fileTypeSize;
  
  /// Pourcentage d'utilisation du stockage
  double get usagePercentage => totalSize > 0 ? usedSize / totalSize * 100 : 0;
  
  /// Espace utilisé formaté
  String get formattedUsedSize {
    if (usedSize < 1024) {
      return '$usedSize o';
    } else if (usedSize < 1024 * 1024) {
      return '${(usedSize / 1024).toStringAsFixed(1)} Ko';
    } else if (usedSize < 1024 * 1024 * 1024) {
      return '${(usedSize / (1024 * 1024)).toStringAsFixed(1)} Mo';
    } else {
      return '${(usedSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} Go';
    }
  }
  
  /// Espace total formaté
  String get formattedTotalSize {
    if (totalSize < 1024) {
      return '$totalSize o';
    } else if (totalSize < 1024 * 1024) {
      return '${(totalSize / 1024).toStringAsFixed(1)} Ko';
    } else if (totalSize < 1024 * 1024 * 1024) {
      return '${(totalSize / (1024 * 1024)).toStringAsFixed(1)} Mo';
    } else {
      return '${(totalSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} Go';
    }
  }
  
  StorageStatistics({
    required this.totalSize,
    required this.usedSize,
    required this.availableSize,
    required this.totalFiles,
    required this.totalFolders,
    required this.fileTypeCount,
    required this.fileTypeSize,
  });
  
  /// Copie les statistiques avec de nouvelles valeurs
  StorageStatistics copyWith({
    int? totalSize,
    int? usedSize,
    int? availableSize,
    int? totalFiles,
    int? totalFolders,
    Map<FileType, int>? fileTypeCount,
    Map<FileType, int>? fileTypeSize,
  }) {
    return StorageStatistics(
      totalSize: totalSize ?? this.totalSize,
      usedSize: usedSize ?? this.usedSize,
      availableSize: availableSize ?? this.availableSize,
      totalFiles: totalFiles ?? this.totalFiles,
      totalFolders: totalFolders ?? this.totalFolders,
      fileTypeCount: fileTypeCount ?? this.fileTypeCount,
      fileTypeSize: fileTypeSize ?? this.fileTypeSize,
    );
  }
}
