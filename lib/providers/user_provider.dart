import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umkamu/models/user.dart';
import 'package:umkamu/services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  final firestoreService = FirestoreService();

  String _id;
  String _foto;
  String _nama;
  String _jenis_kelamin;
  String _email;
  String _password;
  String _whatsapp;
  String _rekening;
  String _tipe;
  int _poin;
  int _komisi;
  int _royalty;
  String _leader;
  String _temp_file;

  // Getter
  String get id => _id;

  String get foto => _foto;

  String get nama => _nama;

  String get jenis_kelamin => _jenis_kelamin;

  String get email => _email;

  String get password => _password;

  String get whatsapp => _whatsapp;

  String get rekening => _rekening;

  String get tipe => _tipe;

  int get poin => _poin;

  int get komisi => _komisi;

  int get royalty => _royalty;

  String get temp_file => _temp_file;

  String get leader => _leader;

  // Setter
  set id(String value) {
    _id = value;
    notifyListeners();
  }

  set foto(String value) {
    _foto = value;
    notifyListeners();
  }

  set nama(String value) {
    _nama = value;
    notifyListeners();
  }

  set jenis_kelamin(String value) {
    _jenis_kelamin = value;
    notifyListeners();
  }

  set tipe(String value) {
    _tipe = value;
    notifyListeners();
  }

  set whatsapp(String value) {
    _whatsapp = value;
    notifyListeners();
  }

  set rekening(String value) {
    _rekening = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set poin(int value) {
    _poin = value;
    notifyListeners();
  }

  set komisi(int value) {
    _komisi = value;
    notifyListeners();
  }

  set royalty(int value) {
    _royalty = value;
    notifyListeners();
  }

  set temp_file(String value) {
    _temp_file = value;
    notifyListeners();
  }

  set leader(String value) {
    _leader = value;
  }

  set user(User user) {
    id = user.id;
    foto = user.foto;
    nama = user.nama;
    jenis_kelamin = user.jenis_kelamin;
    email = user.email;
    password = user.password;
    whatsapp = user.whatsapp;
    rekening = user.rekening;
    poin = user.poin;
    komisi = user.komisi;
    royalty = user.royalty;
    tipe = user.tipe;
    leader = user.leader;
  }

  save() async {
    User user;
    /*if (id == null) {
      String millis = DateTime.now().millisecondsSinceEpoch.toString();
      user = User(
          id: millis,
          foto: temp_file != null
              ? await firestoreService.uploadFile(
                  'users/foto/' + millis, File(_temp_file))
              : foto,
          nama: nama,
          jenis_kelamin: jenis_kelamin,
          email: email,
          password: password,
          whatsapp: whatsapp,
          rekening: rekening,
          poin: poin,
          komisi: komisi,
          royalty: royalty,
          tipe: tipe,
          leader: leader);
    } else {*/
    user = User(
        id: id,
        foto: temp_file != null
            ? await firestoreService.uploadFile(
                'users/foto/' + id, File(temp_file))
            : foto,
        nama: nama,
        jenis_kelamin: jenis_kelamin,
        email: email.toLowerCase(),
        password: password,
        whatsapp: whatsapp,
        rekening: rekening,
        poin: poin,
        komisi: komisi,
        royalty: royalty,
        tipe: tipe,
        leader: leader);
//    }
    firestoreService.saveUser(user);
  }

  remove(String id) async {
    firestoreService.removeFile(await firestoreService.getRef(foto));
    firestoreService.removeUser(id);
  }
}
