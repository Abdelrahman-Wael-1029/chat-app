import 'package:chat_app/features/chat/widget/download_file.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:open_file_plus/open_file_plus.dart';

class FileMessage extends StatefulWidget {
  final MessageModel message;

  const FileMessage({super.key, required this.message});

  @override
  // ignore: library_private_types_in_public_api
  _FileMessageState createState() => _FileMessageState();
}

class _FileMessageState extends State<FileMessage> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        downlaodFile(widget.message.message, true);
      },
      child: const Text('Open File'),
    );
  }
}
