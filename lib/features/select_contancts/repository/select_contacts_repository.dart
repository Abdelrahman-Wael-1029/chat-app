import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_app/common/utils/show_awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../chat/screens/chat_screen.dart';

final selectContactsRepositoryProvider = Provider(
    (ref) => SelectContactsRepository(store: FirebaseFirestore.instance));

class SelectContactsRepository {
  FirebaseFirestore store;

  SelectContactsRepository({required this.store});

  Future<List<Contact>> getContacts() async {
    var users = await store.collection('users').get();
    List<Contact> contacts = [];

    if (await FlutterContacts.requestPermission()) {
      final getContacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
        sorted: true,
      );
      for (var contact in getContacts) {
        var user = _isFound(contact, users);
        if (user != null) {
          contact.displayName = user['name'];
          contact.id = user['id'];
        }
        contacts.add(contact);
      }
    }
    return contacts;
  }

  Future<dynamic> selectContact(context, String uid) async {
    var users = await store.collection('users').get();
    for (var user in users.docs) {
      if (user['id'] == uid) {
        Navigator.pushNamed(
          context,
          ChatScreen.route,
          arguments: {
            'name': user['name'],
            'imageUrl': user['image'],
            'isOnline': user['isOnline'],
            'uid': user['id'],
          },

        );
        return;
      }
    }
    showAwesomeDialog(
      context,
      title: 'Error',
      desc: 'User not found, you can invite them to join Spark.',
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
    );
  }

  dynamic _isFound(Contact contact, users) {
    for (var user in users.docs) {
      if (user['phone'] == contact.phones[0].number.replaceAll(' ', '')) {
        contact.phones[0].number = user['phone'];
        return user;
      }
    }
    return null;
  }
}
