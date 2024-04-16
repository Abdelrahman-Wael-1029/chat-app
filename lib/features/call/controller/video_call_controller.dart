import '../../auth/controller/auth_controller.dart';
import '../repository/video_call_repository.dart';
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
    if (user.value == null) return;
    await videoCallRepository.makeCall(
      reciverId: reciverId,
      senderName: user.value!.name,
    );
  }

  Future<void> endCall(String reciverId) async {
    await videoCallRepository.endCall(reciverId);
  }

  Future<bool> checkInCall(String reciverId) async {
    return await videoCallRepository.checkInCall(reciverId);
  }
}
