import 'dart:math';

import 'package:flutter/material.dart';

import '../../../common/widgets/icon.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.isOnline,
    required this.uid,
  });

  static const String route = '/chat';
  String name;
  String imageUrl;
  bool isOnline;
  String uid;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool notEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.imageUrl),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.isOnline)
                    Text(
                      "Online",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: max(5, MediaQuery.of(context).viewInsets.bottom),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                textDirection: TextDirection.ltr,
                maxLines: 5,
                minLines: 1,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      notEmpty = true;
                    });
                  } else {
                    setState(() {
                      notEmpty = false;
                    });
                  }
                },
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.emoji_emotions_outlined),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                  hintText: "Type a message...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            (!notEmpty)
                ? outlineIcons(
                    context: context,
                    icon: Icon(Icons.mic),
                    onPressed: () {},
                  )
                : outlineIcons(
                    context: context,
                    icon: Icon(Icons.send),
                    onPressed: () {},
                  ),
          ],
        ),
      ),
    );
  }
}
