part of 'document_bloc.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocuments extends DocumentEvent {}

class LoadDocumentsByType extends DocumentEvent {
  final DocumentType type;

  const LoadDocumentsByType(this.type);

  @override
  List<Object> get props => [type];
}

class LoadDocumentsByTag extends DocumentEvent {
  final String tag;

  const LoadDocumentsByTag(this.tag);

  @override
  List<Object> get props => [tag];
}

class LoadDocumentsByEntityId extends DocumentEvent {
  final String entityId;

  const LoadDocumentsByEntityId(this.entityId);

  @override
  List<Object> get props => [entityId];
}

class LoadFavoriteDocuments extends DocumentEvent {}

class SearchDocuments extends DocumentEvent {
  final String query;

  const SearchDocuments(this.query);

  @override
  List<Object> get props => [query];
}

class AddDocument extends DocumentEvent {
  final String name;
  final String description;
  final File file;
  final DocumentType type;
  final List<String> tags;
  final String? associatedEntityId;
  final String? folderId;

  const AddDocument({
    required this.name,
    required this.description,
    required this.file,
    required this.type,
    this.tags = const [],
    this.associatedEntityId,
    this.folderId,
  });

  @override
  List<Object?> get props => [
        name,
        description,
        file,
        type,
        tags,
        associatedEntityId,
        folderId,
      ];
}

class UpdateDocument extends DocumentEvent {
  final Document document;

  const UpdateDocument(this.document);

  @override
  List<Object> get props => [document];
}

class DeleteDocument extends DocumentEvent {
  final String id;

  const DeleteDocument(this.id);

  @override
  List<Object> get props => [id];
}

class ToggleFavorite extends DocumentEvent {
  final String id;
  final bool isFavorite;

  const ToggleFavorite({
    required this.id,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [id, isFavorite];
}

class ViewDocument extends DocumentEvent {
  final String id;

  const ViewDocument(this.id);

  @override
  List<Object> get props => [id];
}

// Événements de dossiers

class LoadFolders extends DocumentEvent {}

class LoadRootFolders extends DocumentEvent {}

class LoadSubfolders extends DocumentEvent {
  final String folderId;

  const LoadSubfolders({required this.folderId});

  @override
  List<Object> get props => [folderId];
}

class LoadDocumentsInFolder extends DocumentEvent {
  final String folderId;

  const LoadDocumentsInFolder({required this.folderId});

  @override
  List<Object> get props => [folderId];
}

class CreateFolder extends DocumentEvent {
  final String name;
  final String? parentId;

  const CreateFolder({
    required this.name,
    this.parentId,
  });

  @override
  List<Object?> get props => [name, parentId];
}

class UpdateFolder extends DocumentEvent {
  final DocumentFolder folder;

  const UpdateFolder(this.folder);

  @override
  List<Object> get props => [folder];
}

class DeleteFolder extends DocumentEvent {
  final String id;

  const DeleteFolder(this.id);

  @override
  List<Object> get props => [id];
}

class AddDocumentToFolder extends DocumentEvent {
  final String documentId;
  final String folderId;

  const AddDocumentToFolder({
    required this.documentId,
    required this.folderId,
  });

  @override
  List<Object> get props => [documentId, folderId];
}

class RemoveDocumentFromFolder extends DocumentEvent {
  final String documentId;
  final String folderId;

  const RemoveDocumentFromFolder({
    required this.documentId,
    required this.folderId,
  });

  @override
  List<Object> get props => [documentId, folderId];
}
