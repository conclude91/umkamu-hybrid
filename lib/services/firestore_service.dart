import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:umkamu/models/user.dart';

class FirestoreService {
  Firestore _db = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> saveUser(User user) {
    return _db.collection('users').document(user.id).setData(user.toMap());
  }

  Stream<List<User>> getAllUser() {
    return _db.collection('users').snapshots().map((snapshot) => snapshot
        .documents
        .map((document) => User.fromFirestore(document.data))
        .toList());
  }

  Future<void> removeUser(String id) {
    return _db.collection('users').document(id).delete();
  }

  Future<String> uploadFile(String name, File file) async {
    StorageReference ref = _storage.ref().child('users/foto/' + name);
    StorageUploadTask uploadTask = ref.putFile(file);

    var url = await (await uploadTask.onComplete).ref.getDownloadURL();
    return url.toString();
  }

  Future<StorageReference> getRef(String url) {
    return _storage.getReferenceFromUrl(url);
  }

  Future<void> removeFile(StorageReference ref) {
    return ref.delete();
  }
}
