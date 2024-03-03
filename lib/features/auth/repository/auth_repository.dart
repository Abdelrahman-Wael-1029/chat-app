import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/utils/show_awesome_dialog.dart';
import '../screens/otp.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
      storage: FirebaseStorage.instance,
      auth: FirebaseAuth.instance,
    ));

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
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) async{
          showAwesomeDialog(context, desc: e.message!, dialogType: DialogType.error);

        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.pushNamed(context, OTPScreen.route,
              arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (String code) {},
      );
    } on FirebaseException catch (e) {
      showAwesomeDialog(context, desc: e.message!, dialogType: DialogType.error);
    } catch (e) {

       showAwesomeDialog(context, desc: e.toString());
    }
  }

  void verifyOTP({
    required context,
    required String verificationId,
    required String smsCode,
  }) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await auth.signInWithCredential(phoneAuthCredential);
    Navigator.pushNamedAndRemoveUntil(context, 'error now', (route) => false);
  }
}
