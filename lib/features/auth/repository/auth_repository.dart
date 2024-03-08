import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_app/common/repository/common_firebase_storage.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/utils/show_awesome_dialog.dart';
import '../screens/otp.dart';
import '../screens/user_info.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    store: FirebaseFirestore.instance,
    commonFirebaseStorageRepositoryProvider:
        ref.read(commonFirebaseStorageRepositoryProvider),
  ),
);

class AuthRepository {
  FirebaseAuth auth;
  FirebaseFirestore store;
  CommonFirebaseStorageRepository commonFirebaseStorageRepositoryProvider;

  AuthRepository({
    required this.auth,
    required this.store,
    required this.commonFirebaseStorageRepositoryProvider,
  });

  void signInWithPhone(context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) async {
          showAwesomeDialog(context,
              desc: e.message!, dialogType: DialogType.error);
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.pushNamed(context, OTPScreen.route,
              arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (String code) {},
      );
    } on FirebaseException catch (e) {
      showAwesomeDialog(context,
          desc: e.message!, dialogType: DialogType.error);
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
    Navigator.pushNamedAndRemoveUntil(
        context, UserInfoScreen.route, (route) => false);
  }

  void saveUserData({
    required context,
    required String name,
    String? image,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      if (image != null) {
        image = await commonFirebaseStorageRepositoryProvider.uploadFile(
            "profilePic/$uid.png", File(image));
      } else {
        image =
            'https://p7.hiclipart.com/preview/782/114/405/5bbc3519d674c.jpg';
      }
      UserModel user = UserModel(
        id: auth.currentUser!.uid,
        name: name,
        phone: auth.currentUser!.phoneNumber!,
        image: image,
        groupsId: [],
        isOnline: true,
      );

      await store.collection('users').doc(uid).set(user.toMap());
    } on FirebaseException catch (e) {
      showAwesomeDialog(context,
          desc: e.message!, dialogType: DialogType.error);
    } catch (e) {
      showAwesomeDialog(context, desc: e.toString());
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      if (auth.currentUser == null) {
        return null;
      }
      DocumentSnapshot<Map<String, dynamic>> user = await store.collection(
          'users').doc(auth.currentUser!.uid).get();

      if(user.data() != null){
        return UserModel.fromJson(user.data()!);
      }
      return null;
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}
