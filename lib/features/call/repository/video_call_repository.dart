import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videoCallRepositoryProvider = Provider(
  (ref) => VideoCallRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class VideoCallRepository {
  FirebaseAuth auth;
  FirebaseFirestore firestore;

  VideoCallRepository({required this.auth, required this.firestore});

  Future<void> makeCall(
      {required String reciverId, required String senderName}) async {
    final call = firestore.collection('calls').doc(reciverId);
    // check if the call is already made
    final callData = await call.get();
    if (callData.exists) {
      return;
    }
    final senderId = auth.currentUser!.uid;
    await call.set({
      'senderId': senderId,
      'senderName': senderName,
      'reciverId': reciverId,
      'time': DateTime.now().toString(),
    });
  }

  Future<void> endCall(String reciverId) async {
    final call = firestore.collection('calls').doc(reciverId);
    await call.delete();
  }

  Future<bool> checkInCall(String reciverId) async{
    final call = firestore.collection('calls').doc(reciverId);
    final callData = await call.get();
    return callData.exists;
  }
}
