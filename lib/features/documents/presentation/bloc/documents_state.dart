part of 'documents_bloc.dart';

abstract class DocumentsState extends Equatable {
  const DocumentsState();
  
  @override
  List<Object> get props => [];
}

class DocumentsInitial extends DocumentsState {}

class DocumentsLoading extends DocumentsState {}

class DocumentsLoaded extends DocumentsState {
  final List<Map<String, dynamic>> documents;
  
  const DocumentsLoaded({required this.documents});
  
  @override
  List<Object> get props => [documents];
}

class DocumentsError extends DocumentsState {
  final String message;
  
  const DocumentsError(this.message);
  
  @override
  List<Object> get props => [message];
}

class DocumentGenerating extends DocumentsState {}

class DocumentGenerated extends DocumentsState {
  final Map<String, dynamic> document;
  
  const DocumentGenerated({required this.document});
  
  @override
  List<Object> get props => [document];
}
