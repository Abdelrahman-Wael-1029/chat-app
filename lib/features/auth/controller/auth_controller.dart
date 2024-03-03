import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref){
  final authRepository = ref.read(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});

class AuthController {
  AuthRepository authRepository;

  AuthController({required this.authRepository});

  void signInWithPhone(context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber,);
  }
}
