import 'dart:io';

import 'package:chat_app/features/stories/controller/stories_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class ConfirmStory extends ConsumerStatefulWidget {
  File file;
  
  static const String route = '/confirm-story';

  ConfirmStory({Key? key, required this.file}) : super(key: key);

  @override
  ConsumerState<ConfirmStory> createState() => _ConfirmStoryState();
}

class _ConfirmStoryState extends ConsumerState<ConfirmStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Story'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Image.file(
                widget.file,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(storiesControllerProvider).addStory(
            userName: 'userName',
            phone: 'phone',
            userImage: 'userImage',
            context: context,
            image: widget.file,
            ref: ref,
          );
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
