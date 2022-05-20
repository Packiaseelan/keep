import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:keep/models/notes_model.dart';

class FirebaseDatabaseService {
  final databaseReference = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  Future saveNotes(NotesModel notes) async {
    var id = databaseReference.child('notes/').push();
    id.set(notes.toJson());
  }

  Future<List<NotesResponse>> getData() async {
    final userId = _auth.currentUser?.uid;
    var databaseEvent =  await databaseReference.child('notes/').orderByChild('userId').equalTo(userId).once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;
    var notes = <NotesResponse> [];
    if (dataSnapshot.value != null) {
      final keyVal = dataSnapshot.value as Map<dynamic, dynamic>;
      keyVal.forEach((k, v) {
        notes.add(NotesResponse.fromJson({'key': k, 'value': v}));
      });
    }
    return notes;
  }

  Future<void> delete(String key) async {
    databaseReference.child('notes/$key').remove();
  }

  Future<void> update(String key, NotesModel notes) async {
    databaseReference.child('notes/$key').update(notes.toJson());
  }
}
