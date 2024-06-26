import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../models/message.dart';

// ignore: must_be_immutable
class VideoMessage extends StatefulWidget {
  MessageModel message;

  VideoMessage({super.key, required this.message});

  @override
  // ignore: library_private_types_in_public_api
  _VideoMessageState createState() => _VideoMessageState();
}
// build using Chewie

class _VideoMessageState extends State<VideoMessage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.message.message));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
      showControls: true,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: min(200, MediaQuery.of(context).size.height * 0.4),
      child: Chewie(controller: _chewieController),
    );
  }
}
