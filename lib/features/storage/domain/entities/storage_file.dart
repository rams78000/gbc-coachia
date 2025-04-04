import 'package:flutter/material.dart';

/// Enum représentant les types de fichier
enum FileType {
  document,
  image,
  audio,
  video,
  pdf,
  spreadsheet,
  presentation,
  archive,
  other;
  
  /// Nom d'affichage du type
  String get displayName {
    switch (this) {
      case FileType.document:
        return 'Document';
      case FileType.image:
        return 'Image';
      case FileType.audio:
        return 'Audio';
      case FileType.video:
        return 'Vidéo';
      case FileType.pdf:
        return 'PDF';
      case FileType.spreadsheet:
        return 'Tableur';
      case FileType.presentation:
        return 'Présentation';
      case FileType.archive:
        return 'Archive';
      case FileType.other:
        return 'Autre';
    }
  }
  
  /// Couleur associée au type
  Color get color {
    switch (this) {
      case FileType.document:
        return Colors.blue;
      case FileType.image:
        return Colors.purple;
      case FileType.audio:
        return Colors.orange;
      case FileType.video:
        return Colors.red;
      case FileType.pdf:
        return Colors.deepOrange;
      case FileType.spreadsheet:
        return Colors.green;
      case FileType.presentation:
        return Colors.amber;
      case FileType.archive:
        return Colors.brown;
      case FileType.other:
        return Colors.grey;
    }
  }
  
  /// Icône associée au type
  IconData get icon {
    switch (this) {
      case FileType.document:
        return Icons.description;
      case FileType.image:
        return Icons.image;
      case FileType.audio:
        return Icons.audiotrack;
      case FileType.video:
        return Icons.videocam;
      case FileType.pdf:
        return Icons.picture_as_pdf;
      case FileType.spreadsheet:
        return Icons.table_chart;
      case FileType.presentation:
        return Icons.slideshow;
      case FileType.archive:
        return Icons.folder_zip;
      case FileType.other:
        return Icons.insert_drive_file;
    }
  }
  
  /// Détermine le type de fichier à partir de l'extension
  static FileType fromExtension(String extension) {
    final ext = extension.toLowerCase();
    
    switch (ext) {
      case 'doc':
      case 'docx':
      case 'txt':
      case 'rtf':
      case 'odt':
        return FileType.document;
      
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'svg':
      case 'webp':
        return FileType.image;
      
      case 'mp3':
      case 'wav':
      case 'ogg':
      case 'flac':
      case 'm4a':
        return FileType.audio;
      
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'mkv':
      case 'webm':
        return FileType.video;
      
      case 'pdf':
        return FileType.pdf;
      
      case 'xls':
      case 'xlsx':
      case 'csv':
      case 'ods':
        return FileType.spreadsheet;
      
      case 'ppt':
      case 'pptx':
      case 'odp':
        return FileType.presentation;
      
      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
      case 'gz':
        return FileType.archive;
      
      default:
        return FileType.other;
    }
  }
}

/// Entité représentant un fichier dans le stockage
class StorageFile {
  final String id;
  final String name;
  final String path;
  final String? url;
  final String extension;
  final int size;
  final FileType type;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isFavorite;
  final bool isShared;
  final String? thumbnail;
  
  /// Obtient le type de fichier à partir de l'extension
  FileType get fileType => type;
  
  /// Indique si le fichier peut être prévisualisé
  bool get isPreviewable {
    return type == FileType.image || 
           type == FileType.pdf || 
           type == FileType.document ||
           type == FileType.video;
  }
  
  /// Taille formatée du fichier
  String get formattedSize {
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
  
  StorageFile({
    required this.id,
    required this.name,
    required this.path,
    this.url,
    required this.extension,
    required this.size,
    required this.type,
    required this.createdAt,
    this.updatedAt,
    this.isFavorite = false,
    this.isShared = false,
    this.thumbnail,
  });
  
  /// Copie le fichier avec de nouvelles valeurs
  StorageFile copyWith({
    String? id,
    String? name,
    String? path,
    String? url,
    String? extension,
    int? size,
    FileType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    bool? isShared,
    String? thumbnail,
  }) {
    return StorageFile(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      url: url ?? this.url,
      extension: extension ?? this.extension,
      size: size ?? this.size,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isShared: isShared ?? this.isShared,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}
