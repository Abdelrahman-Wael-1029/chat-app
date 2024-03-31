import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';

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
      var type = widget.message.message.split('.').last;
      // show file to download and open form phone
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                
              },
              child: Text('Open File'),
            ),
          ],
        ),
      );
  }
}
