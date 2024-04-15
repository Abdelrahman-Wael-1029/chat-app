import 'package:chat_app/features/call/repository/video_call_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videoCallControllerProvider = Provider(
  (ref) => VideoCallController(
    videoCallRepository: ref.watch(videoCallRepositoryProvider),
  ),
);

class VideoCallController {
  VideoCallRepository videoCallRepository;

  VideoCallController({required this.videoCallRepository});

  Future<void> makeCall(String reciverId) async {
    await videoCallRepository.makeCall(reciverId);
  }

  Future<void> endCall(String reciverId) async {
    await videoCallRepository.endCall(reciverId);
  }
}
