part of 'documents_bloc.dart';

abstract class DocumentsEvent extends Equatable {
  const DocumentsEvent();

  @override
  List<Object> get props => [];
}

class LoadDocuments extends DocumentsEvent {}

class CreateDocument extends DocumentsEvent {
  final Map<String, dynamic> document;
  
  const CreateDocument({required this.document});
  
  @override
  List<Object> get props => [document];
}

class UpdateDocument extends DocumentsEvent {
  final String documentId;
  final Map<String, dynamic> updates;
  
  const UpdateDocument({
    required this.documentId,
    required this.updates,
  });
  
  @override
  List<Object> get props => [documentId, updates];
}

class DeleteDocument extends DocumentsEvent {
  final String documentId;
  
  const DeleteDocument({required this.documentId});
  
  @override
  List<Object> get props => [documentId];
}

class GenerateDocument extends DocumentsEvent {
  final String type;
  final Map<String, dynamic> parameters;
  
  const GenerateDocument({
    required this.type,
    required this.parameters,
  });
  
  @override
  List<Object> get props => [type, parameters];
}
