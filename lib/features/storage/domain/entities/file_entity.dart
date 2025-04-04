/// Entité représentant un fichier dans le système de stockage
class FileEntity {
  final String id;
  final String name;
  final String path;
  final String? extension;
  final int size;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String? thumbnailUrl;
  
  FileEntity({
    required this.id,
    required this.name,
    required this.path,
    this.extension,
    required this.size,
    required this.createdAt,
    required this.modifiedAt,
    this.thumbnailUrl,
  });
  
  /// Vérifie si c'est un dossier
  bool get isDirectory => extension == null;
  
  /// Obtient l'URL complet du fichier
  String get fullPath => '$path/$name${extension != null ? '.$extension' : ''}';
}
