import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactsRepositoryProvider = Provider(
    (ref) => SelectContactsRepository(store: FirebaseFirestore.instance));

class SelectContactsRepository {
  FirebaseFirestore store;

  SelectContactsRepository({required this.store});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    var users = await store.collection('users').get();

    if (await FlutterContacts.requestPermission()) {
      final getContacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
        sorted: true,
      );
      contacts = getContacts;
    }
    return contacts;
  }

  dynamic isFound(Contact contact, users) {
    for (var user in users.docs) {
      if (user['phone'] == contact.phones[0].number.replaceAll(' ', '')) {
        contact.phones[0].number = user['phone'];
        return user;
      }
    }
    return null;
  }
}
