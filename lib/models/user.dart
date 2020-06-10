import 'package:flutter/cupertino.dart';

class User {
  final String id;
  final String nama;
  final String email;
  final String password;
  final String whatsapp;
  final String tipe;

  User({
    @required this.id,
    @required this.nama,
    @required this.email,
    @required this.password,
    @required this.whatsapp,
    @required this.tipe,
  });
}
