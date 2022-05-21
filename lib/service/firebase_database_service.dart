import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:keep/models/notes_model.dart';
import 'package:keep/models/shared_with_model.dart';
import 'package:keep/models/user_model.dart';

class FirebaseDatabaseService {
  final databaseReference = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  Future saveNotes(NotesModel notes) async {
    var id = databaseReference.child('notes/').push();
    id.set(notes.toJson());
  }

  Future<List<NotesResponse>> getData() async {
    final userId = _auth.currentUser?.uid;
    var databaseEvent = await databaseReference.child('notes/').orderByChild('userId').equalTo(userId).once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;
    var notes = <NotesResponse>[];
    if (dataSnapshot.value != null) {
      final keyVal = dataSnapshot.value as Map<dynamic, dynamic>;
      keyVal.forEach((k, v) {
        notes.add(NotesResponse.fromJson({'key': k, 'value': v}));
      });
    }
    return notes;
  }

  Future<NotesResponse> getNoteBy(String noteId) async {
    var databaseEvent = await databaseReference.child('notes/$noteId').once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;
    final keyVal = dataSnapshot.value as Map<dynamic, dynamic>;
    var note = NotesResponse.fromJson({'key': noteId, 'value': keyVal});
    return note;
  }

  Future<void> delete(String key) async {
    databaseReference.child('notes/$key').remove();
  }

  Future<void> update(String key, NotesModel notes) async {
    databaseReference.child('notes/$key').update(notes.toJson());
  }

  Future saveUser(UserModel user) async {
    var id = databaseReference.child('users/').push();
    id.set(user.toJson());
  }

  Future<List<UserModel>> getUsers() async {
    var databaseEvent = await databaseReference.child('users/').once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;
    var users = <UserModel>[];
    if (dataSnapshot.value != null) {
      final keyVal = dataSnapshot.value as Map<dynamic, dynamic>;
      keyVal.forEach((k, v) {
        users.add(UserModel.fromJson(v));
      });
    }
    return users;
  }

  Future<UserModel> getUserBy(String userId) async {
    var databaseEvent = await databaseReference.child('users/').orderByChild('userId').equalTo(userId).once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;
    var users = <UserModel>[];
    if (dataSnapshot.value != null) {
      final keyVal = dataSnapshot.value as Map<dynamic, dynamic>;
      keyVal.forEach((k, v) {
        users.add(UserModel.fromJson(v));
      });
    }
    return users.first;
  }

  Future saveSharedWith(List<SharedWithModel> shared) async {
    for (var share in shared) {
      var id = databaseReference.child('sharedWith/').push();
      id.set(share.toJson());
    }
  }

  Future<List<SharedWithModel>> getSharedWith(String noteId) async {
    var databaseEvent = await databaseReference.child('sharedWith/').orderByChild('noteId').equalTo(noteId).once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;
    var users = <SharedWithModel>[];
    if (dataSnapshot.value != null) {
      final keyVal = dataSnapshot.value as Map<dynamic, dynamic>;
      keyVal.forEach((k, v) {
        users.add(SharedWithModel.fromJson(v));
      });
    }
    return users;
  }

  Future<List<SharedWithModel>> getSharedWithUser(String userId) async {
    var databaseEvent = await databaseReference.child('sharedWith/').orderByChild('userId').equalTo(userId).once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;
    var users = <SharedWithModel>[];
    if (dataSnapshot.value != null) {
      final keyVal = dataSnapshot.value as Map<dynamic, dynamic>;
      keyVal.forEach((k, v) {
        users.add(SharedWithModel.fromJson(v));
      });
    }
    return users;
  }
}
