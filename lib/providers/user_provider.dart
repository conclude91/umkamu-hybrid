import 'package:flutter/material.dart';
import 'package:umkamu/models/user.dart';
import 'package:umkamu/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class UserProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  var uuid = Uuid();
  // uuid.v4();

  String _id;
  String _nama;
  String _email;
  String _password;
  String _whatsapp;
  String _tipe;

  // Getter
  String get id => _id;

  String get nama => _nama;

  String get email => _email;

  String get password => _password;

  String get whatsapp => _whatsapp;

  String get tipe => _tipe;

  // Setter
  setId(String value) {
    _id = value;
    notifyListeners();
  }

  setNama(String value) {
    _nama = value;
    notifyListeners();
  }

  setTipe(String value) {
    _tipe = value;
    notifyListeners();
  }

  setWhatsapp(String value) {
    _whatsapp = value;
    notifyListeners();
  }

  setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  saveUser() {
    setTipe('customer');
    final User user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nama: nama,
        email: email,
        password: password,
        whatsapp: whatsapp,
        tipe: tipe);
    firestoreService.saveUser(user);
  }
}
