import 'package:flutter/cupertino.dart';

class Contact {
  final String id;
  final String no_modal;
  final String no_franchise;
  final String no_tanya;
  final String no_teknis;

  Contact({
    @required this.id,
    @required this.no_modal,
    @required this.no_franchise,
    @required this.no_tanya,
    @required this.no_teknis,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'no_modal': no_modal,
      'no_franchise': no_franchise,
      'no_tanya': no_tanya,
      'no_teknis': no_teknis,
    };
  }

  Contact.fromFirestore(Map<String, dynamic> firestore)
      : id = firestore['id'],
        no_modal = firestore['no_modal'],
        no_franchise = firestore['no_franchise'],
        no_tanya = firestore['no_tanya'],
        no_teknis = firestore['no_teknis'];
}
