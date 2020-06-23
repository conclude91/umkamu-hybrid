import 'package:flutter/material.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class FranchiseProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  var uuid = Uuid();

  // uuid.v4();

  String _id;
  String _foto1;
  String _foto2;
  String _foto3;
  String _nama;
  String _kota;
  String _deskripsi;
  String _whatsapp;
  String _kategori;

  String get id => _id;

  setId(String value) {
    _id = value;
  }

  String get foto1 => _foto1;

  setFoto1(String value) {
    _foto1 = value;
  }

  String get foto2 => _foto2;

  setFoto2(String value) {
    _foto2 = value;
  }

  String get foto3 => _foto3;

  setFoto3(String value) {
    _foto3 = value;
  }

  String get nama => _nama;

  setNama(String value) {
    _nama = value;
  }

  String get kota => _kota;

  setKota(String value) {
    _kota = value;
  }

  String get deskripsi => _deskripsi;

  setDeskripsi(String value) {
    _deskripsi = value;
  }

  String get whatsapp => _whatsapp;

  setWhatsapp(String value) {
    _whatsapp = value;
  }

  String get kategori => _kategori;

  setKategori(String value) {
    _kategori = value;
  }

  setFranchise(Franchise franchise) {
    setId(franchise.id);
    setFoto1(franchise.foto1);
    setFoto2(franchise.foto2);
    setFoto3(franchise.foto3);
    setNama(franchise.nama);
    setKota(franchise.kota);
    setDeskripsi(franchise.deskripsi);
    setWhatsapp(franchise.whatsapp);
    setKategori(franchise.kategori);
  }

  saveFranchise() async {
    Franchise franchise;
    if (_id == null) {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      /*String fotoUrl = await firestoreService.uploadFile(id, File(foto));*/
      franchise = Franchise(
          id: id,
          foto1: foto1,
          foto2: foto2,
          foto3: foto3,
          nama: nama,
          kota: kota,
          whatsapp: whatsapp,
          deskripsi: deskripsi,
          kategori: kategori);
    } else {
//      String fotoUrl = await firestoreService.uploadFile(id, File(foto));
      franchise = Franchise(
          id: id,
          foto1: foto1,
          foto2: foto2,
          foto3: foto3,
          nama: nama,
          kota: kota,
          whatsapp: whatsapp,
          deskripsi: deskripsi,
          kategori: kategori);
    }
    firestoreService.saveFranchise(franchise);
  }

  removeUser(String id) async {
    //firestoreService.removeFile(await firestoreService.getRef(foto));
    firestoreService.removeUser(id);
  }

  removeFranchise(String id) async {
    //firestoreService.removeFile(await firestoreService.getRef(foto));
    firestoreService.removeFranchise(id);
  }
}
