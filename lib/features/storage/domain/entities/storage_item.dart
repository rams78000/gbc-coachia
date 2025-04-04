import 'package:gbc_coachia/features/storage/domain/entities/storage_file.dart';
import 'package:gbc_coachia/features/storage/domain/entities/storage_folder.dart';

/// Enum pour le type d'élément de stockage
enum StorageItemType {
  file,
  folder;
}

/// Classe abstraite pour représenter un élément de stockage (fichier ou dossier)
abstract class StorageItem {
  String get id;
  String get name;
  String get path;
  DateTime get createdAt;
  DateTime? get updatedAt;
  bool get isFavorite;
  bool get isShared;
  StorageItemType get itemType;
}

/// Extension pour convertir un StorageFile en StorageItem
extension StorageFileToItem on StorageFile {
  StorageItem toItem() {
    return StorageFileItem(file: this);
  }
}

/// Extension pour convertir un StorageFolder en StorageItem
extension StorageFolderToItem on StorageFolder {
  StorageItem toItem() {
    return StorageFolderItem(folder: this);
  }
}

/// Implémentation de StorageItem pour un fichier
class StorageFileItem implements StorageItem {
  final StorageFile file;
  
  StorageFileItem({required this.file});
  
  @override
  String get id => file.id;
  
  @override
  String get name => file.name;
  
  @override
  String get path => file.path;
  
  @override
  DateTime get createdAt => file.createdAt;
  
  @override
  DateTime? get updatedAt => file.updatedAt;
  
  @override
  bool get isFavorite => file.isFavorite;
  
  @override
  bool get isShared => file.isShared;
  
  @override
  StorageItemType get itemType => StorageItemType.file;
  
  /// Obtient le fichier associé
  StorageFile get fileItem => file;
}

/// Implémentation de StorageItem pour un dossier
class StorageFolderItem implements StorageItem {
  final StorageFolder folder;
  
  StorageFolderItem({required this.folder});
  
  @override
  String get id => folder.id;
  
  @override
  String get name => folder.name;
  
  @override
  String get path => folder.path;
  
  @override
  DateTime get createdAt => folder.createdAt;
  
  @override
  DateTime? get updatedAt => folder.updatedAt;
  
  @override
  bool get isFavorite => folder.isFavorite;
  
  @override
  bool get isShared => folder.isShared;
  
  @override
  StorageItemType get itemType => StorageItemType.folder;
  
  /// Obtient le dossier associé
  StorageFolder get folderItem => folder;
}
