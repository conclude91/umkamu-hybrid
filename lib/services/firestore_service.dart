import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/models/user.dart';

class FirestoreService {
  Firestore _db = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> saveFranchise(Franchise franchise) {
    return _db
        .collection('franchises')
        .document(franchise.id)
        .setData(franchise.toMap());
  }

  Future<void> saveUser(User user) {
    return _db.collection('users').document(user.id).setData(user.toMap());
  }

  Stream<List<User>> getAllUser() {
    return _db.collection('users').snapshots().map((snapshot) => snapshot
        .documents
        .map((document) => User.fromFirestore(document.data))
        .toList());
  }

  Stream<List<User>> getAllUserLeader() {
    return _db
        .collection('users')
        .where('leader', isEqualTo: 'Tidak')
        .where('jenis_kelamin', isEqualTo: 'Laki-Laki')
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((document) => User.fromFirestore(document.data))
            .toList());
  }

  Stream<List<Franchise>> getAllFranchise() {
    return _db.collection('franchises').snapshots().map((snapshot) => snapshot
        .documents
        .map((document) => Franchise.fromFirestore(document.data))
        .toList());
  }

  Future<void> removeUser(String id) {
    return _db.collection('users').document(id).delete();
  }

  Future<void> removeFranchise(String id) {
    return _db.collection('franchises').document(id).delete();
  }

  Future<String> uploadFile(String path, File file) async {
    StorageReference ref = _storage.ref().child(path);
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
