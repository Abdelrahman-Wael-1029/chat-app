import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../common/repository/common_firebase_storage.dart';
import '../../../common/utils/show_awesome_dialog.dart';
import '../../../models/contact.dart';
import '../../../models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/enum_message.dart';

var chatRepositoryProvider = Provider((ref) => ChatRepository(
      store: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      commonStorageRepositoryProvider:
          ref.read(commonFirebaseStorageRepositoryProvider),
    ));

class ChatRepository {
  FirebaseFirestore store;
  FirebaseAuth auth;
  CommonFirebaseStorageRepository commonStorageRepositoryProvider;

  ChatRepository({
    required this.store,
    required this.auth,
    required this.commonStorageRepositoryProvider,
  });

  Stream<List<ContactModel>> getContacts() {
    return store
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chat')
        .orderBy('time', descending: true)
        .snapshots()
        .asyncMap((event) async {
      List<ContactModel> contacts = [];
      for (var doc in event.docs) {
        var user = await store.collection('users').doc(doc.id).get();
        var contact = ContactModel.fromJson(user.data()!);
        var lastMessageInfo = await store
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('chat')
            .doc(doc.id)
            .get();
        contact.lastMessage = lastMessageInfo['lastMessage'];
        var time = DateTime.parse(lastMessageInfo['time']);
        if (time.day == DateTime.now().day) {
          contact.time = '${time.hour}:${time.minute}';
        } else if (time.day == DateTime.now().day - 1) {
          contact.time = 'Yesterday';
        } else {
          contact.time = '${time.day}/${time.month}/${time.year}';
        }
        contacts.add(contact);
      }
      return contacts;
    });
  }

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

  Future<void> sendTextMessage({required context, required message}) async {

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
      await setLastMessage(message);
    }).catchError((e) {
      showAwesomeDialog(
        context,
        dialogType: DialogType.error,
        title: 'Error2',
        desc: e.toString(),
      );
    });
  }

  Future<void> setLastMessage(message) async {
    String? lastMessage;
    switch (message.messageType) {
      case MessageType.text:
        lastMessage = message.message;
        break;
      case MessageType.image:
        lastMessage = 'Image 📷';
        break;
      case MessageType.video:
        lastMessage = 'Video 📸';
        break;
      case MessageType.audio:
        lastMessage = 'Audio 🔉';
        break;
      case MessageType.file:
        lastMessage = 'File 📁';
        break;
    }
    await store
        .collection('users')
        .doc(message.senderId)
        .collection('chat')
        .doc(message.receiverId)
        .set({
      'lastMessage': lastMessage,
      'time': message.time,
    });

    await store
        .collection('users')
        .doc(message.receiverId)
        .collection('chat')
        .doc(message.senderId)
        .set({
      'lastMessage': lastMessage,
      'time': message.time,
    });
  }

  Future<void> sendFileMessage({
    required context,
    required MessageModel message,
    required file,
  }) async {
    await store.runTransaction((transaction) async {
      // create new doc id for message
      String messageId = store
          .collection('users')
          .doc(message.senderId)
          .collection('chat')
          .doc(message.receiverId)
          .collection('messages')
          .doc()
          .id;
      String imageUrl = await commonStorageRepositoryProvider.uploadFile(
          'chat/${message.senderId}/${message.receiverId}/$messageId', file);
      message.message = imageUrl;
      sendTextMessage(context: context, message: message);
    });
  }

  Future<void> setMessages({
    required context,
    required MessageModel message,
  }) async {
    switch (message.messageType) {
      case MessageType.text:
        if (message.message.isEmpty) return;
        await sendTextMessage(context: context, message: message);
        break;
      case MessageType.image:
        File file = File(message.message);
        await sendFileMessage(context: context, message: message, file: file);
        break;
      case MessageType.video:
        File file = File(message.message);
        await sendFileMessage(context: context, message: message, file: file);
        break;
      case MessageType.audio:
        break;
      case MessageType.file:
        File file = File(message.message);
        await sendFileMessage(context: context, message: message, file: file);
        break;
    }
  }
}
