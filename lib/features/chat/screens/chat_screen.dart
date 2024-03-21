import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/show_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/widgets/enum_message.dart';
import '../../../common/widgets/icon.dart';
import '../../../common/widgets/loading.dart';
import '../../../styles/colors.dart';
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
  String name;
  String imageUrl;
  bool isOnline;
  String uid;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with WidgetsBindingObserver {
  bool notEmpty = false;
  bool isKeyboardVisible = false;
  var textController = TextEditingController();
  var scrollController = ScrollController();

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollToEnd();
        }
      });
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final newIsKeyboardVisible = bottomInset > 0.0;

    // If the keyboard visibility has changed, update the state
    if (isKeyboardVisible != newIsKeyboardVisible) {
      setState(() {
        isKeyboardVisible = newIsKeyboardVisible;
      });

      // Perform your actions here
      if (isKeyboardVisible) {
        print('Keyboard opened');
        // make scroll by the height of the keyboard
        print(bottomInset);
        scrollController.animateTo(
          scrollController.position.pixels + bottomInset,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
        // Add your action for keyboard open event
      } else {
        print('Keyboard closed');
        // Add your action for keyboard close event
      }
    }
  }

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
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 5,
        ),
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

            var data = snapshot.data!;

            return ListView.separated(
              shrinkWrap: true,
              controller: scrollController,
              itemBuilder: (context, index) {
                if (data[index].senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return myMessage(context, data[index]);
                }
                return otherMessage(context, data[index]);
              },
              separatorBuilder: (context, index) {
                if (index >= data.length - 1 ||
                    data[index].senderId != data[index + 1].senderId) {
                  return const SizedBox(
                    height: 10,
                  );
                }
                return const SizedBox(
                  height: 4,
                );
              },
              itemCount: data.length,
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
                onSubmitted: (value) {
                  //   close the keyboard
                },
                keyboardType: TextInputType.text,
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
                        onPressed: () async {
                          final XFile? media = await ImagePicker().pickMedia();
                          if (media != null) {
                            chatController.setMessages(
                              context: context,
                              message: MessageModel(
                                message: media.path,
                                senderId:
                                    FirebaseAuth.instance.currentUser!.uid,
                                receiverId: widget.uid,
                                time: DateTime.now().toString(),
                                isRead: false,
                                messageType: MessageType.file,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.attach_file),
                      ),
                      IconButton(
                        onPressed: () async {
                          final XFile? photo = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          if (photo != null) {
                            chatController.setMessages(
                              context: context,
                              message: MessageModel(
                                message: photo.path,
                                senderId:
                                    FirebaseAuth.instance.currentUser!.uid,
                                receiverId: widget.uid,
                                time: DateTime.now().toString(),
                                isRead: false,
                                messageType: MessageType.image,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                  hintText: "Type a message...",
                  hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
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
                      sendMessage(chatController);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void sendMessage(chatController) {
    chatController
        .setMessages(
      context: context,
      message: MessageModel(
        message: textController.text,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        receiverId: widget.uid,
        time: DateTime.now().toString(),
        isRead: false,
      ),
    )
        .then((value) {
      scrollToEnd();
    });
    setState(() {
      textController.clear();
      notEmpty = false;
    });
  }

  void scrollToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent, // Scroll to max position
      duration: const Duration(milliseconds: 100), // Adjust animation duration
      curve: Curves.easeInOut, // Customize scrolling animation (optional)
    );
  }

  Widget myMessage(context, MessageModel message) {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    // Select the color based on the theme
    final containerColor =
        isDarkMode ? DarkColors.messageColor : LightColors.messageColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsetsDirectional.only(end: 10),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: const BorderRadiusDirectional.only(
                bottomEnd: Radius.elliptical(10, 5),
                topStart: Radius.circular(10),
              ),
            ),
            child: SizedBox(
              child: getMessage(message),
            ),
          ),
        ),
      ],
    );
  }

  Widget getMessage(MessageModel message) {
    switch (message.messageType) {
      case MessageType.text:
        return getTextMessage(message);
      case MessageType.image:
        return getImageMessage(message);
      case MessageType.video:
        return Text('Video');
      case MessageType.audio:
        return Text('Audio');
      case MessageType.file:
        return getFileMessage(message);
      case MessageType.GIF:
        return Text('GIF');
    }
  }

  Widget getTextMessage(MessageModel message) {
    return Text(
      message.message,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget getImageMessage(MessageModel message) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ShowImage.route,
            arguments: message.message);
      },
      child: CachedNetworkImage(
        imageUrl: message.message,
        placeholder: (context, url) => const Loading(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.cover,
        width: double.infinity,
        height: max(100, MediaQuery.of(context).size.width * 0.4),
      ),
    );
  }

  Widget getFileMessage(MessageModel message) {
    File file = File(message.message);
    return Text(
      file.path.split('/').last,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget otherMessage(context, MessageModel message) {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final containerColor = isDarkMode
        ? DarkColors.senderMessageColor
        : LightColors.senderMessageColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: const BorderRadiusDirectional.only(
                bottomStart: Radius.elliptical(5, 10),
                topEnd: Radius.circular(10),
              ),
            ),
            child: getMessage(message),
          ),
        ),
      ],
    );
  }
}
