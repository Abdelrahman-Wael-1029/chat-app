import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_app/common/utils/show_awesome_dialog.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var chatRepositoryProvider = Provider((ref) => ChatRepository(
      store: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ));

class ChatRepository {
  FirebaseFirestore store;
  FirebaseAuth auth;

  ChatRepository({
    required this.store,
    required this.auth,
  });

  Stream<List<MessageModel>> getMessages({
    required String receiverId,
  }) {
    final messages = StreamController<List<MessageModel>>();

    store
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .listen((event) {
      final updateMessages =
          event.docs.map((e) => MessageModel.fromJson(e.data())).toList();
      messages.add(updateMessages);
    });
    return messages.stream;
  }

  Future<void> setMessages({
    required context,
    required MessageModel message,
  }) async {
    try {
      await store.runTransaction((transaction) async {
        await store
            .collection('users')
            .doc(message.senderId)
            .collection('chat')
            .doc(message.receiverId)
            .collection('messages')
            .add(message.toJson());
        await store
            .collection('users')
            .doc(message.receiverId)
            .collection('chat')
            .doc(message.senderId)
            .collection('messages')
            .add(message.toJson());
      });
    } catch (e) {
      showAwesomeDialog(
        context,
        dialogType: DialogType.error,
        title: 'Error',
        desc: e.toString(),
      );
    }
  }
}
