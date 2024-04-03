import 'dart:io';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
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
        // downlaod file in 'spark/downloads' directory
//You can download a single file
        File? file = await FileDownloader.downloadFile(
          url: widget.message.message,
          // name: "THE FILE NAME AFTER DOWNLOADING", //(optional)
          onProgress: (String? fileName, double progress) {
            print('FILE fileName HAS PROGRESS $progress');
          },
          onDownloadCompleted: (String path) {
            print('FILE IS NOW AT: $path');
            OpenFile.open(path);
          },
          onDownloadError: (String error) {
            print('FILE DOWNLOAD ERROR: $error');
          },
        );
      },
      child: const Text('Open File'),
    );
  }
}
