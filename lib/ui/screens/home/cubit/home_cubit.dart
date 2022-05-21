import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep/config/service_locator.dart';
import 'package:keep/models/notes_model.dart';
import 'package:keep/service/firebase_database_service.dart';
import 'package:keep/ui/screens/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  HomeCubit() : super(HomeInitial());

  Future<void> getNotes() async {
    final list = await serviceLocator<FirebaseDatabaseService>().getData();
  var pinned = <NotesResponse> [];
  var others = <NotesResponse> [];
    for (var e in list) {
      if (e.value!.isPinned == true) {
        pinned.add(e);
      } else {
        others.add(e);
      }
    }

    emit(HomeNotesState(
      pinnedNotes: pinned,
      notes: others));
  }

  Future<void> saveNotes(String title, String description, bool isPinned) async {
    final notes = NotesModel(
        userId: _firebaseAuth.currentUser?.uid,
        dateTime: DateTime.now().millisecondsSinceEpoch,
        title: title,
        description: description,
        isPinned: isPinned);
    await serviceLocator<FirebaseDatabaseService>().saveNotes(notes);

    getNotes();
  }

  Future<void> pinnedNotes(NotesResponse note, bool isPinned) async {
    final n = note.value!;
    n.isPinned = isPinned;
    await serviceLocator<FirebaseDatabaseService>().update(note.key!, n);

    getNotes();
  }

  Future<void> updateNotes(NotesResponse note) async {
    await serviceLocator<FirebaseDatabaseService>().update(note.key!, note.value!);

    getNotes();
  }

  Future<void> delete(String key) async {
    await serviceLocator<FirebaseDatabaseService>().delete(key);
    getNotes();
  }
}
