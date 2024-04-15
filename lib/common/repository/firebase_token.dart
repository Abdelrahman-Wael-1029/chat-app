import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseTokenProvider = Provider(
  (ref) => FirebaseToken(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class FirebaseToken {
  FirebaseFirestore firestore;
  FirebaseAuth auth;

  FirebaseToken({required this.auth, required this.firestore});

  void storeToken(String token) async {
    var uid = auth.currentUser!.uid;

    FirebaseFirestore.instance.collection('tokens').doc(uid).set({
      'token': token,
    });
  }

  Future<String> getToken(uid) async {
    var token =
        await FirebaseFirestore.instance.collection('tokens').doc(uid).get();
    return token['token'];
  }
}
