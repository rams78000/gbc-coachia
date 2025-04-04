part of 'document_bloc.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();
  
  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentState {}

// États pour la liste des documents
class DocumentsLoading extends DocumentState {}

class DocumentsLoaded extends DocumentState {
  final List<Document> documents;
  final String? activeFilter;

  const DocumentsLoaded({
    required this.documents,
    this.activeFilter,
  });

  @override
  List<Object?> get props => [documents, activeFilter];
}

class DocumentsInFolderLoaded extends DocumentState {
  final List<Document> documents;
  final DocumentFolder folder;

  const DocumentsInFolderLoaded({
    required this.documents,
    required this.folder,
  });

  @override
  List<Object> get props => [documents, folder];
}

class DocumentsError extends DocumentState {
  final String message;

  const DocumentsError({required this.message});

  @override
  List<Object> get props => [message];
}

// États pour un document spécifique
class DocumentLoading extends DocumentState {
  final String id;

  const DocumentLoading({required this.id});

  @override
  List<Object> get props => [id];
}

class DocumentLoaded extends DocumentState {
  final Document document;
  final File file;

  const DocumentLoaded({
    required this.document,
    required this.file,
  });

  @override
  List<Object> get props => [document, file];
}

class DocumentUploading extends DocumentState {}

class DocumentUploaded extends DocumentState {
  final Document document;

  const DocumentUploaded({required this.document});

  @override
  List<Object> get props => [document];
}

class DocumentUpdated extends DocumentState {
  final Document document;

  const DocumentUpdated({required this.document});

  @override
  List<Object> get props => [document];
}

class DocumentDeleted extends DocumentState {
  final String id;

  const DocumentDeleted({required this.id});

  @override
  List<Object> get props => [id];
}

// États pour les dossiers
class FoldersLoading extends DocumentState {}

class FoldersLoaded extends DocumentState {
  final List<DocumentFolder> folders;
  final String? parentFolderId;

  const FoldersLoaded({
    required this.folders,
    this.parentFolderId,
  });

  @override
  List<Object?> get props => [folders, parentFolderId];
}

class FolderCreated extends DocumentState {
  final DocumentFolder folder;

  const FolderCreated({required this.folder});

  @override
  List<Object> get props => [folder];
}

class FolderUpdated extends DocumentState {
  final DocumentFolder folder;

  const FolderUpdated({required this.folder});

  @override
  List<Object> get props => [folder];
}

class FolderDeleted extends DocumentState {
  final String id;

  const FolderDeleted({required this.id});

  @override
  List<Object> get props => [id];
}
