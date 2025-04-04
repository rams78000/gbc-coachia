import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum DocumentType {
  invoice,
  contract,
  report,
  receipt,
  proposal,
  legal,
  tax,
  image,
  pdf,
  spreadsheet,
  presentation,
  text,
  other,
}

class Document extends Equatable {
  final String id;
  final String name;
  final String description;
  final String path; // Chemin du fichier local
  final String? url; // URL pour les documents en ligne
  final DocumentType type;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  final int size; // Taille en octets
  final bool isFavorite;
  final String? thumbnailPath;
  final String? associatedEntityId; // ID d'une transaction ou d'un événement associé

  const Document({
    required this.id,
    required this.name,
    this.description = '',
    required this.path,
    this.url,
    required this.type,
    this.tags = const [],
    required this.createdAt,
    this.modifiedAt,
    required this.size,
    this.isFavorite = false,
    this.thumbnailPath,
    this.associatedEntityId,
  });

  /// Crée un nouveau document avec un ID généré automatiquement
  factory Document.create({
    required String name,
    String description = '',
    required String path,
    String? url,
    required DocumentType type,
    List<String> tags = const [],
    DateTime? createdAt,
    DateTime? modifiedAt,
    required int size,
    bool isFavorite = false,
    String? thumbnailPath,
    String? associatedEntityId,
  }) {
    final uuid = const Uuid().v4();
    return Document(
      id: uuid,
      name: name,
      description: description,
      path: path,
      url: url,
      type: type,
      tags: tags,
      createdAt: createdAt ?? DateTime.now(),
      modifiedAt: modifiedAt,
      size: size,
      isFavorite: isFavorite,
      thumbnailPath: thumbnailPath,
      associatedEntityId: associatedEntityId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        path,
        url,
        type,
        tags,
        createdAt,
        modifiedAt,
        size,
        isFavorite,
        thumbnailPath,
        associatedEntityId,
      ];

  Document copyWith({
    String? id,
    String? name,
    String? description,
    String? path,
    String? url,
    DocumentType? type,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? modifiedAt,
    int? size,
    bool? isFavorite,
    String? thumbnailPath,
    String? associatedEntityId,
  }) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      path: path ?? this.path,
      url: url ?? this.url,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      size: size ?? this.size,
      isFavorite: isFavorite ?? this.isFavorite,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      associatedEntityId: associatedEntityId ?? this.associatedEntityId,
    );
  }

  // Conversion depuis/vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'path': path,
      'url': url,
      'type': type.index,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt?.toIso8601String(),
      'size': size,
      'isFavorite': isFavorite,
      'thumbnailPath': thumbnailPath,
      'associatedEntityId': associatedEntityId,
    };
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      path: json['path'] as String,
      url: json['url'] as String?,
      type: DocumentType.values[json['type'] as int],
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: json['modifiedAt'] != null
          ? DateTime.parse(json['modifiedAt'] as String)
          : null,
      size: json['size'] as int,
      isFavorite: json['isFavorite'] as bool? ?? false,
      thumbnailPath: json['thumbnailPath'] as String?,
      associatedEntityId: json['associatedEntityId'] as String?,
    );
  }
}

class DocumentFolder extends Equatable {
  final String id;
  final String name;
  final String? parentId; // ID du dossier parent (null si c'est un dossier racine)
  final List<String> documentIds; // IDs des documents dans ce dossier
  final List<String> subfolderIds; // IDs des sous-dossiers
  final DateTime createdAt;
  final DateTime? modifiedAt;

  const DocumentFolder({
    required this.id,
    required this.name,
    this.parentId,
    this.documentIds = const [],
    this.subfolderIds = const [],
    required this.createdAt,
    this.modifiedAt,
  });

  /// Crée un nouveau dossier avec un ID généré automatiquement
  factory DocumentFolder.create({
    required String name,
    String? parentId,
    List<String> documentIds = const [],
    List<String> subfolderIds = const [],
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    final uuid = const Uuid().v4();
    return DocumentFolder(
      id: uuid,
      name: name,
      parentId: parentId,
      documentIds: documentIds,
      subfolderIds: subfolderIds,
      createdAt: createdAt ?? DateTime.now(),
      modifiedAt: modifiedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        parentId,
        documentIds,
        subfolderIds,
        createdAt,
        modifiedAt,
      ];

  DocumentFolder copyWith({
    String? id,
    String? name,
    String? parentId,
    List<String>? documentIds,
    List<String>? subfolderIds,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return DocumentFolder(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      documentIds: documentIds ?? this.documentIds,
      subfolderIds: subfolderIds ?? this.subfolderIds,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  // Conversion depuis/vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parentId': parentId,
      'documentIds': documentIds,
      'subfolderIds': subfolderIds,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt?.toIso8601String(),
    };
  }

  factory DocumentFolder.fromJson(Map<String, dynamic> json) {
    return DocumentFolder(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parentId'] as String?,
      documentIds: (json['documentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      subfolderIds: (json['subfolderIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: json['modifiedAt'] != null
          ? DateTime.parse(json['modifiedAt'] as String)
          : null,
    );
  }
}
