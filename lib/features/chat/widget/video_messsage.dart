import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

import '../../../models/message.dart';

class VideoMessage extends StatefulWidget {
  MessageModel message;

  VideoMessage({super.key, required this.message});

  @override
  _VideoMessageState createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.message.message),
      ),
      autoPlay: false,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(
      flickManager: flickManager,
    );
  }
}
