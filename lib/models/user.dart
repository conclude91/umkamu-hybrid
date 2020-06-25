import 'package:flutter/cupertino.dart';

class User {
  final String id;
  final String foto;
  final String nama;
  final String jenis_kelamin;
  final String email;
  final String password;
  final String whatsapp;
  final String rekening;
  final int poin;
  final int komisi;
  final int royalty;
  final String tipe;

  User({
    @required this.id,
    @required this.foto,
    @required this.nama,
    @required this.jenis_kelamin,
    @required this.email,
    @required this.password,
    @required this.whatsapp,
    @required this.rekening,
    @required this.poin,
    @required this.komisi,
    @required this.royalty,
    @required this.tipe,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foto': foto,
      'nama': nama,
      'jenis_kelamin':jenis_kelamin,
      'email': email,
      'password': password,
      'whatsapp': whatsapp,
      'rekening': rekening,
      'poin': poin,
      'komisi': komisi,
      'royalty': royalty,
      'tipe': tipe,
    };
  }

  User.fromFirestore(Map<String, dynamic> firestore)
      : id = firestore['id'],
        foto = firestore['foto'],
        nama = firestore['nama'],
        jenis_kelamin = firestore['jenis_kelamin'],
        email = firestore['email'],
        password = firestore['password'],
        whatsapp = firestore['whatsapp'],
        rekening = firestore['rekening'],
        poin = firestore['poin'],
        komisi = firestore['komisi'],
        royalty = firestore['royalty'],
        tipe = firestore['tipe'];
}
