import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final _storage = FirebaseStorage.instance.ref();
  final _auth = FirebaseAuth.instance;

  Future<String> uploadFile(File file) async {
    var extension = file.path.split('.')[1];
    final userId = _auth.currentUser?.uid;
    final date = DateTime.now().millisecondsSinceEpoch;
    String filename = '$userId$date.$extension';
    final UploadTask uploadTask = _storage.child('images/$filename').putFile(file);
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }

  Future<void> deleteFile(String path) async {
    final link = path.split('?')[0];
    final child = link.split('/').last;
    final filename = child.split('%2F').last;

    _storage.child('images/$filename').delete();
  }
}