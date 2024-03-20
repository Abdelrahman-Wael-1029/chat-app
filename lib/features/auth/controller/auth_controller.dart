import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});

final authGetCurrentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authController = ref.read(authControllerProvider);
  return await authController.getUserData();
});

class AuthController {
  AuthRepository authRepository;

  AuthController({required this.authRepository});

  void signInWithPhone(context, String phoneNumber) {
    authRepository.signInWithPhone(
      context,
      phoneNumber,
    );
  }

  void verifyOTP({
    required context,
    required String verificationId,
    required String smsCode,
  }) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  void saveUserData({
    required context,
    required String name,
    String? image,
  }){
    authRepository.saveUserData(
      context: context,
      name: name,
      image: image,
    );
  }

  Future<UserModel?> getUserData() async{
    return await authRepository.getUserData();
  }

  void setUserOnline(bool isOnline){
    authRepository.setUserOnline(isOnline);
  }

  void signOut(context) {
    authRepository.signOut(context);
  }
}
