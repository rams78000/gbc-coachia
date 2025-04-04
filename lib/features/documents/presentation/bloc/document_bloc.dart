import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_template.dart';
import 'package:gbc_coachia/features/documents/domain/repositories/document_repository.dart';

// Events
abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocuments extends DocumentEvent {}

class LoadDocumentById extends DocumentEvent {
  final String id;

  const LoadDocumentById(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterDocumentsByType extends DocumentEvent {
  final DocumentType type;

  const FilterDocumentsByType(this.type);

  @override
  List<Object?> get props => [type];
}

class FilterDocumentsByStatus extends DocumentEvent {
  final DocumentStatus status;

  const FilterDocumentsByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class SearchDocuments extends DocumentEvent {
  final String query;

  const SearchDocuments(this.query);

  @override
  List<Object?> get props => [query];
}

class AddDocument extends DocumentEvent {
  final Document document;

  const AddDocument(this.document);

  @override
  List<Object?> get props => [document];
}

class UpdateDocument extends DocumentEvent {
  final Document document;

  const UpdateDocument(this.document);

  @override
  List<Object?> get props => [document];
}

class DeleteDocument extends DocumentEvent {
  final String id;

  const DeleteDocument(this.id);

  @override
  List<Object?> get props => [id];
}

class ChangeDocumentStatus extends DocumentEvent {
  final String id;
  final DocumentStatus newStatus;

  const ChangeDocumentStatus(this.id, this.newStatus);

  @override
  List<Object?> get props => [id, newStatus];
}

class LoadTemplates extends DocumentEvent {}

class LoadTemplateById extends DocumentEvent {
  final String id;

  const LoadTemplateById(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterTemplatesByType extends DocumentEvent {
  final DocumentType type;

  const FilterTemplatesByType(this.type);

  @override
  List<Object?> get props => [type];
}

class AddTemplate extends DocumentEvent {
  final DocumentTemplate template;

  const AddTemplate(this.template);

  @override
  List<Object?> get props => [template];
}

class UpdateTemplate extends DocumentEvent {
  final DocumentTemplate template;

  const UpdateTemplate(this.template);

  @override
  List<Object?> get props => [template];
}

class DeleteTemplate extends DocumentEvent {
  final String id;

  const DeleteTemplate(this.id);

  @override
  List<Object?> get props => [id];
}

class GenerateDocumentFromTemplate extends DocumentEvent {
  final String templateId;
  final Map<String, dynamic> data;
  final String title;

  const GenerateDocumentFromTemplate({
    required this.templateId,
    required this.data,
    required this.title,
  });

  @override
  List<Object?> get props => [templateId, data, title];
}

// States
abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

class DocumentsInitial extends DocumentState {}

class DocumentsLoading extends DocumentState {}

class DocumentsLoaded extends DocumentState {
  final List<Document> documents;

  const DocumentsLoaded(this.documents);

  @override
  List<Object?> get props => [documents];
}

class DocumentLoaded extends DocumentState {
  final Document document;

  const DocumentLoaded(this.document);

  @override
  List<Object?> get props => [document];
}

class DocumentsError extends DocumentState {
  final String message;

  const DocumentsError(this.message);

  @override
  List<Object?> get props => [message];
}

class TemplatesLoading extends DocumentState {}

class TemplatesLoaded extends DocumentState {
  final List<DocumentTemplate> templates;

  const TemplatesLoaded(this.templates);

  @override
  List<Object?> get props => [templates];
}

class TemplateLoaded extends DocumentState {
  final DocumentTemplate template;

  const TemplateLoaded(this.template);

  @override
  List<Object?> get props => [template];
}

class TemplatesError extends DocumentState {
  final String message;

  const TemplatesError(this.message);

  @override
  List<Object?> get props => [message];
}

class DocumentCreated extends DocumentState {
  final Document document;

  const DocumentCreated(this.document);

  @override
  List<Object?> get props => [document];
}

class DocumentUpdated extends DocumentState {
  final Document document;

  const DocumentUpdated(this.document);

  @override
  List<Object?> get props => [document];
}

class DocumentDeleted extends DocumentState {
  final String id;

  const DocumentDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

class DocumentStatusChanged extends DocumentState {
  final Document document;

  const DocumentStatusChanged(this.document);

  @override
  List<Object?> get props => [document];
}

class TemplateCreated extends DocumentState {
  final DocumentTemplate template;

  const TemplateCreated(this.template);

  @override
  List<Object?> get props => [template];
}

class TemplateUpdated extends DocumentState {
  final DocumentTemplate template;

  const TemplateUpdated(this.template);

  @override
  List<Object?> get props => [template];
}

class TemplateDeleted extends DocumentState {
  final String id;

  const TemplateDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

class DocumentGenerationLoading extends DocumentState {}

class DocumentGenerated extends DocumentState {
  final Document document;

  const DocumentGenerated(this.document);

  @override
  List<Object?> get props => [document];
}

class DocumentGenerationError extends DocumentState {
  final String message;

  const DocumentGenerationError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository _documentRepository;

  DocumentBloc(this._documentRepository) : super(DocumentsInitial()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<LoadDocumentById>(_onLoadDocumentById);
    on<FilterDocumentsByType>(_onFilterDocumentsByType);
    on<FilterDocumentsByStatus>(_onFilterDocumentsByStatus);
    on<SearchDocuments>(_onSearchDocuments);
    on<AddDocument>(_onAddDocument);
    on<UpdateDocument>(_onUpdateDocument);
    on<DeleteDocument>(_onDeleteDocument);
    on<ChangeDocumentStatus>(_onChangeDocumentStatus);
    on<LoadTemplates>(_onLoadTemplates);
    on<LoadTemplateById>(_onLoadTemplateById);
    on<FilterTemplatesByType>(_onFilterTemplatesByType);
    on<AddTemplate>(_onAddTemplate);
    on<UpdateTemplate>(_onUpdateTemplate);
    on<DeleteTemplate>(_onDeleteTemplate);
    on<GenerateDocumentFromTemplate>(_onGenerateDocumentFromTemplate);
  }

  Future<void> _onLoadDocuments(LoadDocuments event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final documents = await _documentRepository.getAllDocuments();
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onLoadDocumentById(LoadDocumentById event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final document = await _documentRepository.getDocumentById(event.id);
      if (document != null) {
        emit(DocumentLoaded(document));
      } else {
        emit(const DocumentsError('Document non trouvé'));
      }
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onFilterDocumentsByType(FilterDocumentsByType event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final documents = await _documentRepository.getDocumentsByType(event.type);
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onFilterDocumentsByStatus(FilterDocumentsByStatus event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final documents = await _documentRepository.getDocumentsByStatus(event.status);
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onSearchDocuments(SearchDocuments event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final documents = await _documentRepository.searchDocuments(event.query);
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onAddDocument(AddDocument event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final document = await _documentRepository.addDocument(event.document);
      emit(DocumentCreated(document));
      
      // Recharger la liste complète après l'ajout
      add(LoadDocuments());
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onUpdateDocument(UpdateDocument event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final document = await _documentRepository.updateDocument(event.document);
      emit(DocumentUpdated(document));
      
      // Recharger la liste complète après la mise à jour
      add(LoadDocuments());
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onDeleteDocument(DeleteDocument event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final success = await _documentRepository.deleteDocument(event.id);
      if (success) {
        emit(DocumentDeleted(event.id));
        
        // Recharger la liste complète après la suppression
        add(LoadDocuments());
      } else {
        emit(const DocumentsError('Impossible de supprimer le document'));
      }
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onChangeDocumentStatus(ChangeDocumentStatus event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final document = await _documentRepository.changeDocumentStatus(event.id, event.newStatus);
      emit(DocumentStatusChanged(document));
      
      // Recharger la liste complète après le changement de statut
      add(LoadDocuments());
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onLoadTemplates(LoadTemplates event, Emitter<DocumentState> emit) async {
    emit(TemplatesLoading());
    try {
      final templates = await _documentRepository.getAllTemplates();
      emit(TemplatesLoaded(templates));
    } catch (e) {
      emit(TemplatesError(e.toString()));
    }
  }

  Future<void> _onLoadTemplateById(LoadTemplateById event, Emitter<DocumentState> emit) async {
    emit(TemplatesLoading());
    try {
      final template = await _documentRepository.getTemplateById(event.id);
      if (template != null) {
        emit(TemplateLoaded(template));
      } else {
        emit(const TemplatesError('Modèle non trouvé'));
      }
    } catch (e) {
      emit(TemplatesError(e.toString()));
    }
  }

  Future<void> _onFilterTemplatesByType(FilterTemplatesByType event, Emitter<DocumentState> emit) async {
    emit(TemplatesLoading());
    try {
      final templates = await _documentRepository.getTemplatesByType(event.type);
      emit(TemplatesLoaded(templates));
    } catch (e) {
      emit(TemplatesError(e.toString()));
    }
  }

  Future<void> _onAddTemplate(AddTemplate event, Emitter<DocumentState> emit) async {
    emit(TemplatesLoading());
    try {
      final template = await _documentRepository.addTemplate(event.template);
      emit(TemplateCreated(template));
      
      // Recharger la liste complète après l'ajout
      add(LoadTemplates());
    } catch (e) {
      emit(TemplatesError(e.toString()));
    }
  }

  Future<void> _onUpdateTemplate(UpdateTemplate event, Emitter<DocumentState> emit) async {
    emit(TemplatesLoading());
    try {
      final template = await _documentRepository.updateTemplate(event.template);
      emit(TemplateUpdated(template));
      
      // Recharger la liste complète après la mise à jour
      add(LoadTemplates());
    } catch (e) {
      emit(TemplatesError(e.toString()));
    }
  }

  Future<void> _onDeleteTemplate(DeleteTemplate event, Emitter<DocumentState> emit) async {
    emit(TemplatesLoading());
    try {
      final success = await _documentRepository.deleteTemplate(event.id);
      if (success) {
        emit(TemplateDeleted(event.id));
        
        // Recharger la liste complète après la suppression
        add(LoadTemplates());
      } else {
        emit(const TemplatesError('Impossible de supprimer le modèle'));
      }
    } catch (e) {
      emit(TemplatesError(e.toString()));
    }
  }

  Future<void> _onGenerateDocumentFromTemplate(
    GenerateDocumentFromTemplate event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentGenerationLoading());
    try {
      final document = await _documentRepository.generateDocumentFromTemplate(
        templateId: event.templateId,
        data: event.data,
        title: event.title,
      );
      emit(DocumentGenerated(document));
      
      // Recharger la liste complète après la génération
      add(LoadDocuments());
    } catch (e) {
      emit(DocumentGenerationError(e.toString()));
    }
  }
}
