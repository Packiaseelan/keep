import 'package:keep/models/notes_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeNotesState extends HomeState {
  final List<NotesResponse> pinnedNotes;
  final List<NotesResponse> notes;

  HomeNotesState({
    this.pinnedNotes = const [],
    this.notes = const [],
  });
}
