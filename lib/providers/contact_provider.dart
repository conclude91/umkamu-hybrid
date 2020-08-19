import 'package:flutter/material.dart';
import 'package:umkamu/models/contact.dart';
import 'package:umkamu/services/firestore_service.dart';

class ContactProvider with ChangeNotifier {
  final firestoreService = FirestoreService();

  String _id;
  String _no_modal;
  String _no_franchise;
  String _no_tanya;
  String _no_teknis;

  // Getter
  String get id => _id;

  String get no_modal => _no_modal;

  String get no_tanya => _no_tanya;

  String get no_franchise => _no_franchise;

  String get no_teknis => _no_teknis;

  // Setter
  set id(String value) {
    _id = value;
    notifyListeners();
  }

  set no_modal(String value) {
    _no_modal = value;
  }

  set no_franchise(String value) {
    _no_franchise = value;
  }

  set no_tanya(String value) {
    _no_tanya = value;
  }

  set no_teknis(String value) {
    _no_teknis = value;
  }

  set contact(Contact contact) {
    id = contact.id;
    no_modal = contact.no_modal;
    no_franchise = contact.no_franchise;
    no_tanya = contact.no_tanya;
    no_teknis = contact.no_teknis;
  }

  save() async {
    Contact contact;
    contact = Contact(
        id: id,
        no_modal: no_modal,
        no_franchise: no_franchise,
        no_tanya: no_tanya,
        no_teknis: no_teknis);
    firestoreService.saveContact(contact);
  }

  remove(String id) async {
    firestoreService.removeContact(id);
  }
}
