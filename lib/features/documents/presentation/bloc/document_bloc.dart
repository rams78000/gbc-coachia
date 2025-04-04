import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc_coachai/features/documents/domain/entities/document.dart';
import 'package:gbc_coachai/features/documents/domain/repositories/document_repository.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository repository;

  DocumentBloc({required this.repository}) : super(DocumentInitial()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<LoadDocumentsByType>(_onLoadDocumentsByType);
    on<LoadDocumentsByTag>(_onLoadDocumentsByTag);
    on<LoadDocumentsByEntityId>(_onLoadDocumentsByEntityId);
    on<LoadFavoriteDocuments>(_onLoadFavoriteDocuments);
    on<SearchDocuments>(_onSearchDocuments);
    on<AddDocument>(_onAddDocument);
    on<UpdateDocument>(_onUpdateDocument);
    on<DeleteDocument>(_onDeleteDocument);
    on<ToggleFavorite>(_onToggleFavorite);
    on<ViewDocument>(_onViewDocument);
    
    // Événements de dossiers
    on<LoadFolders>(_onLoadFolders);
    on<LoadRootFolders>(_onLoadRootFolders);
    on<LoadSubfolders>(_onLoadSubfolders);
    on<LoadDocumentsInFolder>(_onLoadDocumentsInFolder);
    on<CreateFolder>(_onCreateFolder);
    on<UpdateFolder>(_onUpdateFolder);
    on<DeleteFolder>(_onDeleteFolder);
    on<AddDocumentToFolder>(_onAddDocumentToFolder);
    on<RemoveDocumentFromFolder>(_onRemoveDocumentFromFolder);
  }

  Future<void> _onLoadDocuments(
    LoadDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentsLoading());
    try {
      final documents = await repository.getDocuments();
      emit(DocumentsLoaded(documents: documents));
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onLoadDocumentsByType(
    LoadDocumentsByType event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentsLoading());
    try {
      final documents = await repository.getDocumentsByType(event.type);
      emit(DocumentsLoaded(
        documents: documents,
        activeFilter: 'Type: ${event.type.toString().split('.').last}',
      ));
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onLoadDocumentsByTag(
    LoadDocumentsByTag event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentsLoading());
    try {
      final documents = await repository.getDocumentsByTag(event.tag);
      emit(DocumentsLoaded(
        documents: documents,
        activeFilter: 'Tag: ${event.tag}',
      ));
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onLoadDocumentsByEntityId(
    LoadDocumentsByEntityId event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentsLoading());
    try {
      final documents = await repository.getDocumentsByEntityId(event.entityId);
      emit(DocumentsLoaded(
        documents: documents,
        activeFilter: 'Associated Entity',
      ));
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onLoadFavoriteDocuments(
    LoadFavoriteDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentsLoading());
    try {
      final documents = await repository.getFavoriteDocuments();
      emit(DocumentsLoaded(
        documents: documents,
        activeFilter: 'Favoris',
      ));
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onSearchDocuments(
    SearchDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentsLoading());
    try {
      if (event.query.isEmpty) {
        final documents = await repository.getDocuments();
        emit(DocumentsLoaded(documents: documents));
      } else {
        final documents = await repository.searchDocuments(event.query);
        emit(DocumentsLoaded(
          documents: documents,
          activeFilter: 'Recherche: ${event.query}',
        ));
      }
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onAddDocument(
    AddDocument event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentUploading());
    try {
      final document = await repository.addDocument(
        name: event.name,
        description: event.description,
        file: event.file,
        type: event.type,
        tags: event.tags,
        associatedEntityId: event.associatedEntityId,
      );
      
      // Si un folderId est fourni, ajouter le document au dossier
      if (event.folderId != null) {
        await repository.addDocumentToFolder(document.id, event.folderId!);
      }
      
      emit(DocumentUploaded(document: document));
      
      // Recharger les documents pour mettre à jour la liste
      add(LoadDocuments());
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateDocument(
    UpdateDocument event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      await repository.updateDocument(event.document);
      
      emit(DocumentUpdated(document: event.document));
      
      // Recharger les documents pour mettre à jour la liste
      add(LoadDocuments());
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onDeleteDocument(
    DeleteDocument event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      await repository.deleteDocument(event.id);
      
      emit(DocumentDeleted(id: event.id));
      
      // Recharger les documents pour mettre à jour la liste
      add(LoadDocuments());
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      await repository.toggleFavorite(event.id, event.isFavorite);
      
      if (state is DocumentsLoaded) {
        final currentState = state as DocumentsLoaded;
        final updatedDocuments = currentState.documents.map((document) {
          if (document.id == event.id) {
            return document.copyWith(isFavorite: event.isFavorite);
          }
          return document;
        }).toList();
        
        emit(DocumentsLoaded(
          documents: updatedDocuments,
          activeFilter: currentState.activeFilter,
        ));
      }
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onViewDocument(
    ViewDocument event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading(id: event.id));
    try {
      final document = await repository.getDocumentById(event.id);
      final file = await repository.getDocumentFile(event.id);
      
      if (document != null && file != null) {
        emit(DocumentLoaded(document: document, file: file));
      } else {
        emit(DocumentsError(message: 'Document not found'));
      }
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  // Gestion des dossiers

  Future<void> _onLoadFolders(
    LoadFolders event,
    Emitter<DocumentState> emit,
  ) async {
    emit(FoldersLoading());
    try {
      final folders = await repository.getFolders();
      emit(FoldersLoaded(folders: folders));
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onLoadRootFolders(
    LoadRootFolders event,
    Emitter<DocumentState> emit,
  ) async {
    emit(FoldersLoading());
    try {
      final folders = await repository.getRootFolders();
      emit(FoldersLoaded(folders: folders));
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onLoadSubfolders(
    LoadSubfolders event,
    Emitter<DocumentState> emit,
  ) async {
    emit(FoldersLoading());
    try {
      final subfolders = await repository.getSubfolders(event.folderId);
      emit(FoldersLoaded(
        folders: subfolders,
        parentFolderId: event.folderId,
      ));
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onLoadDocumentsInFolder(
    LoadDocumentsInFolder event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentsLoading());
    try {
      final documents = await repository.getDocumentsInFolder(event.folderId);
      final folder = await repository.getFolderById(event.folderId);
      
      if (folder != null) {
        emit(DocumentsInFolderLoaded(
          documents: documents,
          folder: folder,
        ));
      } else {
        emit(DocumentsError(message: 'Folder not found'));
      }
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onCreateFolder(
    CreateFolder event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final folder = await repository.createFolder(
        event.name,
        parentId: event.parentId,
      );
      
      emit(FolderCreated(folder: folder));
      
      // Recharger les dossiers pour mettre à jour la liste
      if (event.parentId != null) {
        add(LoadSubfolders(folderId: event.parentId!));
      } else {
        add(LoadRootFolders());
      }
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateFolder(
    UpdateFolder event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      await repository.updateFolder(event.folder);
      
      emit(FolderUpdated(folder: event.folder));
      
      // Recharger les dossiers pour mettre à jour la liste
      if (event.folder.parentId != null) {
        add(LoadSubfolders(folderId: event.folder.parentId!));
      } else {
        add(LoadRootFolders());
      }
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onDeleteFolder(
    DeleteFolder event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final folder = await repository.getFolderById(event.id);
      
      if (folder != null) {
        await repository.deleteFolder(event.id);
        
        emit(FolderDeleted(id: event.id));
        
        // Recharger les dossiers pour mettre à jour la liste
        if (folder.parentId != null) {
          add(LoadSubfolders(folderId: folder.parentId!));
        } else {
          add(LoadRootFolders());
        }
      } else {
        emit(DocumentsError(message: 'Folder not found'));
      }
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onAddDocumentToFolder(
    AddDocumentToFolder event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      await repository.addDocumentToFolder(event.documentId, event.folderId);
      
      // Recharger les documents dans le dossier
      add(LoadDocumentsInFolder(folderId: event.folderId));
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }

  Future<void> _onRemoveDocumentFromFolder(
    RemoveDocumentFromFolder event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      await repository.removeDocumentFromFolder(event.documentId, event.folderId);
      
      // Recharger les documents dans le dossier
      add(LoadDocumentsInFolder(folderId: event.folderId));
    } catch (e) {
      emit(DocumentsError(message: e.toString()));
    }
  }
}
