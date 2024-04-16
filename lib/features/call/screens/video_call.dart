import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../../common/repository/firebase_token.dart';
import '../../../common/repository/notification_api.dart';
import '../../../common/widgets/loading.dart';
import '../../../config/agora_config.dart';
import '../controller/video_call_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCall extends ConsumerStatefulWidget {
  static const String route = '/video-call';
  final String reciverId;

  final senderName;

  const VideoCall(
      {super.key, required this.reciverId, required this.senderName});
  @override
  ConsumerState<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends ConsumerState<VideoCall> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine engine;

  @override
  void initState() {
    super.initState();
    initAgora();
    sendNotification();
  }

  void initAgora() async {
    await [Permission.camera, Permission.microphone].request();
    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
      appId: AgoraConfig.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
          ref.read(videoCallControllerProvider).endCall(widget.reciverId);
          _dispose();
          Navigator.of(context).pop();
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.startPreview();
    await engine.joinChannel(
      token: AgoraConfig.token,
      channelId: AgoraConfig.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );

    ref
        .read(videoCallControllerProvider)
        .makeCall(reciverId: widget.reciverId, ref: ref);
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await engine.leaveChannel();
    await engine.release();
    ref.read(videoCallControllerProvider).endCall(widget.reciverId);
  }

  Offset _dragOffset = Offset.zero;

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        ref.read(videoCallControllerProvider).endCall(widget.reciverId);
        _dispose();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agora Video Call'),
        ),
        body: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            Positioned(
              left: _dragOffset.dx,
              top: _dragOffset.dy,
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  // check not out from screen
                  if (_dragOffset.dx + details.delta.dx < 0) {
                    // reset
                    setState(() {
                      _dragOffset =
                          Offset(0, _dragOffset.dy + details.delta.dy);
                    });
                    return;
                  }
                  if (_dragOffset.dy + details.delta.dy < 0) {
                    setState(() {
                      _dragOffset =
                          Offset(_dragOffset.dx + details.delta.dx, 0);
                    });
                    return;
                  }

                  if (_dragOffset.dx + details.delta.dx >
                      MediaQuery.of(context).size.width - 100) {
                    setState(() {
                      _dragOffset = Offset(
                        MediaQuery.of(context).size.width - 100,
                        _dragOffset.dy + details.delta.dy,
                      );
                    });
                    return;
                  }
                  if (_dragOffset.dy + details.delta.dy >
                      MediaQuery.of(context).size.height - 150) {
                    setState(() {
                      _dragOffset = Offset(
                        _dragOffset.dx + details.delta.dx,
                        MediaQuery.of(context).size.height - 150,
                      );
                    });
                    return;
                  }
                  setState(() {
                    _dragOffset += details.delta;
                  });
                },
                child: SizedBox(
                  width: 100,
                  height: 150,
                  child: Center(
                    child: _localUserJoined
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: engine,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          )
                        : const Loading(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: AgoraConfig.channelName),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  void sendNotification() async {

    var remoteToken =
        await ref.read(firebaseTokenProvider).getToken(widget.reciverId);
    ref.read(notificationApiProvider).sendFcmNotification(
        token: remoteToken,
        title: 'Incoming Call form ${widget.senderName}',
        body: 'You have an incoming video call',
        data: {
          'type': 'video_call',
          'senderName': widget.senderName,
          'reciverId': widget.reciverId,
        });
  }
}
