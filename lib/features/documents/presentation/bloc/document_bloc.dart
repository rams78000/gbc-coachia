import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_template.dart';
import 'package:gbc_coachia/features/documents/domain/repositories/document_repository.dart';

// Events
abstract class DocumentEvent {}

class LoadDocuments extends DocumentEvent {}

class LoadDocumentById extends DocumentEvent {
  final String id;
  
  LoadDocumentById(this.id);
}

class CreateDocument extends DocumentEvent {
  final Document document;
  
  CreateDocument(this.document);
}

class UpdateDocument extends DocumentEvent {
  final Document document;
  
  UpdateDocument(this.document);
}

class DeleteDocument extends DocumentEvent {
  final String id;
  
  DeleteDocument(this.id);
}

class ChangeDocumentStatus extends DocumentEvent {
  final String id;
  final DocumentStatus status;
  
  ChangeDocumentStatus(this.id, this.status);
}

class LoadTemplates extends DocumentEvent {}

class LoadTemplateById extends DocumentEvent {
  final String id;
  
  LoadTemplateById(this.id);
}

class CreateTemplate extends DocumentEvent {
  final DocumentTemplate template;
  
  CreateTemplate(this.template);
}

class UpdateTemplate extends DocumentEvent {
  final DocumentTemplate template;
  
  UpdateTemplate(this.template);
}

class DeleteTemplate extends DocumentEvent {
  final String id;
  
  DeleteTemplate(this.id);
}

class GenerateDocumentFromTemplate extends DocumentEvent {
  final String templateId;
  final Map<String, dynamic> data;
  final String title;
  
  GenerateDocumentFromTemplate({
    required this.templateId,
    required this.data,
    required this.title,
  });
}

class FilterDocumentsByType extends DocumentEvent {
  final DocumentType type;
  
  FilterDocumentsByType(this.type);
}

class FilterDocumentsByStatus extends DocumentEvent {
  final DocumentStatus status;
  
  FilterDocumentsByStatus(this.status);
}

class FilterTemplatesByType extends DocumentEvent {
  final DocumentType type;
  
  FilterTemplatesByType(this.type);
}

// States
abstract class DocumentState {}

class DocumentsInitial extends DocumentState {}

class DocumentsLoading extends DocumentState {}

class DocumentsLoaded extends DocumentState {
  final List<Document> documents;
  
  DocumentsLoaded(this.documents);
}

class DocumentLoaded extends DocumentState {
  final Document document;
  
  DocumentLoaded(this.document);
}

class DocumentsError extends DocumentState {
  final String message;
  
  DocumentsError(this.message);
}

class TemplatesLoading extends DocumentState {}

class TemplatesLoaded extends DocumentState {
  final List<DocumentTemplate> templates;
  
  TemplatesLoaded(this.templates);
}

class TemplateLoaded extends DocumentState {
  final DocumentTemplate template;
  
  TemplateLoaded(this.template);
}

class TemplatesError extends DocumentState {
  final String message;
  
  TemplatesError(this.message);
}

class DocumentGenerationLoading extends DocumentState {}

class DocumentGenerated extends DocumentState {
  final Document document;
  
  DocumentGenerated(this.document);
}

class DocumentGenerationError extends DocumentState {
  final String message;
  
  DocumentGenerationError(this.message);
}

// BLoC
class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository repository;
  
  DocumentBloc({required this.repository}) : super(DocumentsInitial()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<LoadDocumentById>(_onLoadDocumentById);
    on<CreateDocument>(_onCreateDocument);
    on<UpdateDocument>(_onUpdateDocument);
    on<DeleteDocument>(_onDeleteDocument);
    on<ChangeDocumentStatus>(_onChangeDocumentStatus);
    on<LoadTemplates>(_onLoadTemplates);
    on<LoadTemplateById>(_onLoadTemplateById);
    on<CreateTemplate>(_onCreateTemplate);
    on<UpdateTemplate>(_onUpdateTemplate);
    on<DeleteTemplate>(_onDeleteTemplate);
    on<GenerateDocumentFromTemplate>(_onGenerateDocumentFromTemplate);
    on<FilterDocumentsByType>(_onFilterDocumentsByType);
    on<FilterDocumentsByStatus>(_onFilterDocumentsByStatus);
    on<FilterTemplatesByType>(_onFilterTemplatesByType);
  }
  
  void _onLoadDocuments(LoadDocuments event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final documents = await repository.getDocuments();
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }
  
  void _onLoadDocumentById(LoadDocumentById event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final document = await repository.getDocumentById(event.id);
      emit(DocumentLoaded(document));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }
  
  void _onCreateDocument(CreateDocument event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final document = await repository.createDocument(event.document);
      emit(DocumentLoaded(document));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }
  
  void _onUpdateDocument(UpdateDocument event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final document = await repository.updateDocument(event.document);
      emit(DocumentLoaded(document));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }
  
  void _onDeleteDocument(DeleteDocument event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      await repository.deleteDocument(event.id);
      final documents = await repository.getDocuments();
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }
  
  void _onChangeDocumentStatus(ChangeDocumentStatus event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final document = await repository.changeDocumentStatus(event.id, event.status);
      emit(DocumentLoaded(document));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }
  
  void _onLoadTemplates(LoadTemplates event, Emitter<DocumentState> emit) async {
    emit(TemplatesLoading());
    try {
      final templates = await repository.getTemplates();
      emit(TemplatesLoaded(templates));
    } catch (e) {
      emit(TemplatesError(e.toString()));
    }
  }
  
  void _onLoadTemplateById(LoadTemplateById event, Emitter<DocumentState> emit) async {
    emit(TemplatesLoading());
    try {
      final template = await repository.getTemplateById(event.id);
      emit(TemplateLoaded(template));
    } catch (e) {
      emit(TemplatesError(e.toString()));
    }
  }
  
  void _onCreateTemplate(CreateTemplate event, Emitter<DocumentState> emit) async {
    emit(TemplatesLoading());
    try {
      final template = await repository.createTemplate(event.template);
      emit(TemplateLoaded(template));
    } catch (e) {
      emit(TemplatesError(e.toString()));
    }
  }
  
  void _onUpdateTemplate(UpdateTemplate event, Emitter<DocumentState> emit) async {
    emit(TemplatesLoading());
    try {
      final template = await repository.updateTemplate(event.template);
      emit(TemplateLoaded(template));
    } catch (e) {
      emit(TemplatesError(e.toString()));
    }
  }
  
  void _onDeleteTemplate(DeleteTemplate event, Emitter<DocumentState> emit) async {
    emit(TemplatesLoading());
    try {
      await repository.deleteTemplate(event.id);
      final templates = await repository.getTemplates();
      emit(TemplatesLoaded(templates));
    } catch (e) {
      emit(TemplatesError(e.toString()));
    }
  }
  
  void _onGenerateDocumentFromTemplate(GenerateDocumentFromTemplate event, Emitter<DocumentState> emit) async {
    emit(DocumentGenerationLoading());
    try {
      final document = await repository.generateDocumentFromTemplate(
        templateId: event.templateId,
        data: event.data,
        title: event.title,
      );
      emit(DocumentGenerated(document));
    } catch (e) {
      emit(DocumentGenerationError(e.toString()));
    }
  }
  
  void _onFilterDocumentsByType(FilterDocumentsByType event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final documents = await repository.filterDocumentsByType(event.type);
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }
  
  void _onFilterDocumentsByStatus(FilterDocumentsByStatus event, Emitter<DocumentState> emit) async {
    emit(DocumentsLoading());
    try {
      final documents = await repository.filterDocumentsByStatus(event.status);
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }
  
  void _onFilterTemplatesByType(FilterTemplatesByType event, Emitter<DocumentState> emit) async {
    emit(TemplatesLoading());
    try {
      final templates = await repository.filterTemplatesByType(event.type);
      emit(TemplatesLoaded(templates));
    } catch (e) {
      emit(TemplatesError(e.toString()));
    }
  }
}
