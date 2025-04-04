/// Entité représentant un dossier dans le stockage
class StorageFolder {
  final String id;
  final String name;
  final String path;
  final int itemCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? parentId;
  final bool isFavorite;
  final bool isShared;
  
  StorageFolder({
    required this.id,
    required this.name,
    required this.path,
    required this.itemCount,
    required this.createdAt,
    this.updatedAt,
    this.parentId,
    this.isFavorite = false,
    this.isShared = false,
  });
  
  /// Copie le dossier avec de nouvelles valeurs
  StorageFolder copyWith({
    String? id,
    String? name,
    String? path,
    int? itemCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? parentId,
    bool? isFavorite,
    bool? isShared,
  }) {
    return StorageFolder(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      itemCount: itemCount ?? this.itemCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      parentId: parentId ?? this.parentId,
      isFavorite: isFavorite ?? this.isFavorite,
      isShared: isShared ?? this.isShared,
    );
  }
}
