import 'package:flutter_bloc/flutter_bloc.dart';

// Placeholder pour le bloc de documents
class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  DocumentsBloc() : super(DocumentsInitial()) {
    // TODO: Implémenter la logique pour les documents
  }
}

abstract class DocumentsEvent {}
abstract class DocumentsState {}
class DocumentsInitial extends DocumentsState {}
