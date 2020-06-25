import 'dart:io';
import 'package:flutter/material.dart';
import 'package:umkamu/models/user.dart';
import 'package:umkamu/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class UserProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  var uuid = Uuid();

  // uuid.v4();

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

  // Setter
  setPoin(int value) {
    _poin = value;
  }

  setId(String value) {
    _id = value;
    notifyListeners();
  }

  setFoto(String value) {
    _foto = value;
    notifyListeners();
  }

  setNama(String value) {
    _nama = value;
    notifyListeners();
  }

  setJenisKelamin(String value) {
    _jenis_kelamin = value;
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

  setRekening(String value) {
    _rekening = value;
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

  setKomisi(int value) {
    _komisi = value;
  }

  setRoyalty(int value) {
    _royalty = value;
  }

  setUser(User user) {
    setId(user.id);
    setFoto(user.foto);
    setNama(user.nama);
    setJenisKelamin(user.jenis_kelamin);
    setEmail(user.email);
    setPassword(user.password);
    setWhatsapp(user.whatsapp);
    setRekening(user.rekening);
    setPoin(user.poin);
    setKomisi(user.komisi);
    setRoyalty(user.royalty);
    setTipe(user.tipe);
  }

  saveUser() async {
    User user;
    if (_id == null) {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      String fotoUrl = await firestoreService.uploadFile(id, File(foto));
      user = User(
          id: id,
          foto: fotoUrl,
          nama: nama,
          jenis_kelamin: jenis_kelamin,
          email: email,
          password: password,
          whatsapp: whatsapp,
          rekening: rekening,
          poin: 0,
          komisi: 0,
          royalty: 0,
          tipe: tipe);
    } else {
      String fotoUrl = await firestoreService.uploadFile(id, File(foto));
      user = User(
          id: id,
          foto: fotoUrl != null ? fotoUrl : foto,
          nama: nama,
          jenis_kelamin: jenis_kelamin,
          email: email,
          password: password,
          whatsapp: whatsapp,
          rekening: rekening,
          poin: poin,
          komisi: komisi,
          royalty: royalty,
          tipe: tipe);
    }
    firestoreService.saveUser(user);
  }

  removeUser(String id) async {
    firestoreService.removeFile(await firestoreService.getRef(foto));
    firestoreService.removeUser(id);
  }
}
