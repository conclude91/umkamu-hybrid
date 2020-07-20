import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/services/firestore_service.dart';

class FranchiseProvider with ChangeNotifier {
  final firestoreService = FirestoreService();

  String _id;
  String _foto1;
  String _foto2;
  String _foto3;
  String _nama;
  String _kota;
  String _deskripsi;
  String _whatsapp;
  String _kategori;
  String _promo;
  String _temp_file1;
  String _temp_file2;
  String _temp_file3;

  // Getter
  String get id => _id;

  String get foto1 => _foto1;

  String get foto2 => _foto2;

  String get foto3 => _foto3;

  String get nama => _nama;

  String get kota => _kota;

  String get deskripsi => _deskripsi;

  String get whatsapp => _whatsapp;

  String get kategori => _kategori;

  String get promo => _promo;

  String get temp_file1 => _temp_file1;

  String get temp_file2 => _temp_file2;

  String get temp_file3 => _temp_file3;

  // Setter
  set id(String value) {
    _id = value;
  }

  set foto1(String value) {
    _foto1 = value;
  }

  set foto2(String value) {
    _foto2 = value;
  }

  set foto3(String value) {
    _foto3 = value;
  }

  set nama(String value) {
    _nama = value;
  }

  set kota(String value) {
    _kota = value;
  }

  set deskripsi(String value) {
    _deskripsi = value;
  }

  set whatsapp(String value) {
    _whatsapp = value;
  }

  set kategori(String value) {
    _kategori = value;
  }

  set promo(String value) {
    _promo = value;
  }

  set temp_file1(String value) {
    _temp_file1 = value;
  }

  set temp_file2(String value) {
    _temp_file2 = value;
  }

  set temp_file3(String value) {
    _temp_file3 = value;
  }

  set franchise(Franchise franchise) {
    id = franchise.id;
    foto1 = franchise.foto1;
    foto2 = franchise.foto2;
    foto3 = franchise.foto3;
    nama = franchise.nama;
    kota = franchise.kota;
    deskripsi = franchise.deskripsi;
    whatsapp = franchise.whatsapp;
    kategori = franchise.kategori;
    promo = franchise.promo;
  }

  save() async {
    Franchise franchise;
    franchise = Franchise(
        id: id,
        foto1: temp_file1 != null
            ? await firestoreService.uploadFile(
                'franchise/foto/' + id + '_foto1', File(temp_file1))
            : foto1,
        foto2: temp_file2 != null
            ? await firestoreService.uploadFile(
                'franchise/foto/' + id + '_foto2', File(temp_file2))
            : foto2,
        foto3: temp_file3 != null
            ? await firestoreService.uploadFile(
                'franchise/foto/' + id + '_foto3', File(temp_file3))
            : foto3,
        nama: nama,
        kota: kota,
        whatsapp: whatsapp,
        deskripsi: deskripsi,
        kategori: kategori,
        promo: promo);

    firestoreService.saveFranchise(franchise);
  }

  remove(String id) async {
    firestoreService.removeFile(await firestoreService.getRef(foto1));
    firestoreService.removeFile(await firestoreService.getRef(foto2));
    firestoreService.removeFile(await firestoreService.getRef(foto3));
    firestoreService.removeFranchise(id);
  }
}
