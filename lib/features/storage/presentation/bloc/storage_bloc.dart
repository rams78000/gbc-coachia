import 'package:flutter_bloc/flutter_bloc.dart';

// Placeholder pour le bloc de stockage
class StorageBloc extends Bloc<StorageEvent, StorageState> {
  StorageBloc() : super(StorageInitial()) {
    // TODO: Implémenter la logique pour le stockage
  }
}

abstract class StorageEvent {}
abstract class StorageState {}
class StorageInitial extends StorageState {}
