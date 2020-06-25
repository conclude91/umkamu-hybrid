import 'package:flutter/cupertino.dart';

class Franchise {
  final String id;
  final String foto1;
  final String foto2;
  final String foto3;
  final String nama;
  final String kota;
  final String deskripsi;
  final String whatsapp;
  final String kategori;

  Franchise({
    @required this.id,
    @required this.foto1,
    @required this.foto2,
    @required this.foto3,
    @required this.nama,
    @required this.kota,
    @required this.deskripsi,
    @required this.whatsapp,
    @required this.kategori,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foto1': foto1,
      'foto2': foto2,
      'foto3': foto3,
      'nama': nama,
      'kota': kota,
      'deskripsi': deskripsi,
      'whatsapp': whatsapp,
      'kategori': kategori,
    };
  }

  Franchise.fromFirestore(Map<String, dynamic> firestore)
      : id = firestore['id'],
        foto1 = firestore['foto1'],
        foto2 = firestore['foto2'],
        foto3 = firestore['foto3'],
        nama = firestore['nama'],
        kota = firestore['kota'],
        deskripsi = firestore['deskripsi'],
        whatsapp = firestore['whatsapp'],
        kategori = firestore['kategori'];
}
