import 'dart:math';

import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/common/widgets/message_chat.dart';
import 'package:chat_app/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/icon.dart';
import '../../../common/widgets/loading.dart';
import '../controller/chat_controller.dart';

class ChatScreen extends ConsumerStatefulWidget {
  ChatScreen({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.isOnline,
    required this.uid,
  });

  static const String route = '/chat';
  var scrollController = ScrollController();
  String name;
  String imageUrl;
  bool isOnline;
  String uid;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool notEmpty = false;
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var chatController = ref.read(chatControllerProvider);
    final messages = chatController.getMessages(receiverId: widget.uid);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: StreamBuilder<List<MessageModel>>(
          stream: messages,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorScreen(
                error: snapshot.error.toString(),
              );
            }

            if (!snapshot.hasData) {
              return const Loading();
            }

            return MessageChat(
              messages: snapshot.data!,
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: max(5, MediaQuery.of(context).viewInsets.bottom),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
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
                  print(notEmpty);
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
                    icon: const Icon(Icons.mic),
                    onPressed: () {},
                  )
                : outlineIcons(
                    context: context,
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (textController.text.isEmpty) return;
                      chatController.setMessages(
                        context: context,
                        message: MessageModel(
                          message: textController.text,
                          senderId: FirebaseAuth.instance.currentUser!.uid,
                          receiverId: widget.uid,
                          time: DateTime.now().toString(),
                          isRead: false,
                        ),
                      );
                      setState(() {
                        textController.clear();
                        notEmpty = false;
                      });
                      //   make scroll to down page
                      widget.scrollController.animateTo(
                        widget.scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
