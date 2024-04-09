import 'package:chat_app/common/widgets/loading.dart';

import '../../../models/message.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioMessage extends StatefulWidget {
  final MessageModel message;

  const AudioMessage({super.key, required this.message});

  @override
  _AudioMessageState createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isSpeed = false;
  @override
  void initState() {
    super.initState();
    loadAudio();
  }

  Widget playing() {
    return (audioPlayer.playing)
        ? IconButton(
            icon: const Icon(Icons.pause),
            onPressed: () async {
              setState(() {});
              await audioPlayer.pause();
            },
          )
        : IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () async {
              setState(() {});
              await audioPlayer.play();
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
        stream: audioPlayer.positionStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || audioPlayer.duration == null) {
            return const Loading();
          }
          return Column(
            children: [
              Slider(
                value: snapshot.data!.inSeconds.toDouble(),
                onChanged: (value) {
                  audioPlayer.seek(Duration(seconds: value.toInt()));
                },
                min: 0.0,
                max: audioPlayer.duration!.inSeconds.toDouble(),
              ),
              Row(
                children: [
                  // icon to play audio
                  playing(),
                  // slider to control audio
                  // time stretching
                  speed(),
                  // duration of audio
                  Spacer(),
                  Text(
                    "${snapshot.data!.inHours}:${snapshot.data!.inMinutes}:${snapshot.data!.inSeconds.remainder(60)}",
                  ),
                  
                ],
              ),
            ],
          );
        });
  }

  void loadAudio() async {
    if (await Permission.storage.isGranted) {
      await audioPlayer.setUrl(widget.message.message);
    } else {
      await Permission.storage.request();
      if (await Permission.storage.isGranted) {
        await audioPlayer.setUrl(widget.message.message);
        await audioPlayer.load();
      }
    }
    audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        // reset
        audioPlayer.seek(Duration.zero);
        audioPlayer.stop();
        setState(() {});
      }
      print("positioon::: " + audioPlayer.position.inSeconds.toString());
    });
  }

  Widget speed() {
    return (isSpeed)
        ? IconButton(
            icon: const Icon(Icons.speed),
            onPressed: () async {
              isSpeed = false;
              await audioPlayer.setSpeed(1.0);
              setState(() {});
            },
            color: Theme.of(context).primaryColor,
          )
        : IconButton(
            icon: const Icon(Icons.speed),
            onPressed: () async {
              isSpeed = true;
              await audioPlayer.setSpeed(2.0);
              setState(() {});
            },
          );
  }
}
