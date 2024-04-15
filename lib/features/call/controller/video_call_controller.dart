import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/call/repository/video_call_repository.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videoCallControllerProvider = Provider(
  (ref) => VideoCallController(
    videoCallRepository: ref.watch(videoCallRepositoryProvider),
  ),
);

class VideoCallController {
  VideoCallRepository videoCallRepository;

  VideoCallController({required this.videoCallRepository});

  Future<void> makeCall({required String reciverId, ref}) async {
    var user = await ref.read(authGetCurrentUserProvider);
    print("daaaataaa: $user");
    if (user.value == null) return;
    await videoCallRepository.makeCall(
      reciverId: reciverId,
      senderName: user.value!.name,
    );
  }

  Future<void> endCall(String reciverId) async {
    await videoCallRepository.endCall(reciverId);
  }
}
