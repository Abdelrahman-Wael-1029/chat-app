import 'package:chat_app/common/utils/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../screens/otp.dart';

class AuthRepository {
  FirebaseAuth auth;
  FirebaseStorage storage;

  AuthRepository({
    required this.storage,
    required this.auth,
  });

  void signInWithPhone(context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) async {
          auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw e.message!;
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.pushNamed(context, OTPScreen.route, arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (String code) {},
      );
    } on FirebaseException catch (e) {
      showSnackBar(context, content: e.message!);
    } catch (e) {}
  }
}
