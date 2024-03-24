import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';

import '../../../common/widgets/error.dart';
import '../widget/text_message.dart';
import '../widget/video_messsage.dart';
import '../../../models/message.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/widgets/enum_message.dart';
import '../../../common/widgets/icon.dart';
import '../../../common/widgets/loading.dart';
import '../../../styles/colors.dart';
import '../controller/chat_controller.dart';
import '../widget/image_message.dart';

// ignore: must_be_immutable
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

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool notEmpty = false;
  bool isKeyboardVisible = false;
  var textController = TextEditingController();
  var emojiController = TextEditingController();
  var scrollController = ScrollController();
  final _focusNode = FocusNode();
  bool showEmoji = false;
  int indexEmojiAdd = 0;


  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
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
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          showEmoji = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var chatController = ref.read(chatControllerProvider);
    final messages = chatController.getMessages(receiverId: widget.uid);

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          bottom: max(5, (MediaQuery.of(context).viewInsets.bottom)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
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
                        onPressed: () async {
                          setState(() {
                            showEmoji = !showEmoji;
                            // get index the fouse cursor
                            indexEmojiAdd = textController.selection.baseOffset;
                          });
                          await Future.delayed(
                                  const Duration(milliseconds: 100))
                              .then((value) {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          });
                        },
                        icon: const Icon(Icons.emoji_emotions_outlined),
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              final XFile? media =
                                  await ImagePicker().pickMedia();
                              if (media == null) return;
                              // ignore: use_build_context_synchronously
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
                            },
                            icon: const Icon(Icons.attach_file),
                          ),
                          InkWell(
                            onLongPress: () async {
                              // vedio
                              final XFile? video = await ImagePicker()
                                  .pickVideo(source: ImageSource.gallery);
                              if (video != null) {
                                // ignore: use_build_context_synchronously
                                chatController.setMessages(
                                  context: context,
                                  message: MessageModel(
                                    message: video.path,
                                    senderId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    receiverId: widget.uid,
                                    time: DateTime.now().toString(),
                                    isRead: false,
                                    messageType: MessageType.video,
                                  ),
                                );
                              }
                            },
                            child: IconButton(
                              onPressed: () async {
                                final XFile? photo = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (photo != null) {
                                  // ignore: use_build_context_synchronously
                                  chatController.setMessages(
                                    context: context,
                                    message: MessageModel(
                                      message: photo.path,
                                      senderId: FirebaseAuth
                                          .instance.currentUser!.uid,
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
                          ),
                        ],
                      ),
                      hintText: "Type a message...",
                      hintStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
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
            if (showEmoji)
              EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  textController.text = textController.text.substring(0, indexEmojiAdd) +
                      emoji.emoji +
                      ((indexEmojiAdd==0)?textController.text.substring(indexEmojiAdd):"");

                  textController.selection = TextSelection.fromPosition(
                    TextPosition(offset: indexEmojiAdd + emoji.emoji.length),
                  );

                  indexEmojiAdd += emoji.emoji.length;

                  checkEmptyTextField(textController.text);
                },
                textEditingController: emojiController,
                config: Config(
                    height: MediaQuery.of(context).size.height * 0.35,
                    categoryViewConfig: CategoryViewConfig(
                      backgroundColor:
                          Theme.of(context).appBarTheme.backgroundColor!,
                      iconColor: Theme.of(context).iconTheme.color!,
                      indicatorColor: Colors.white,
                      iconColorSelected: Colors.white,
                    ),
                    emojiViewConfig: EmojiViewConfig(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                    ),
                    checkPlatformCompatibility: true,
                    bottomActionBarConfig: BottomActionBarConfig(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      showSearchViewButton: false,
                      showBackspaceButton: true,
                      enabled: false,
                    )),
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

    textController.clear();
    emojiController.clear();
    checkEmptyTextField(textController.text);
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
        return TextMessage(message: message);
      case MessageType.image:
        return ImageMessage(message: message);
      case MessageType.video:
        return VideoMessage(
          message: message,
        );
      case MessageType.audio:
        return const Text('Audio');
      case MessageType.file:
        return getFileMessage(message);
      case MessageType.GIF:
        return const Text('GIF');
    }
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

  void checkEmptyTextField(String value) {
    if (value.isNotEmpty) {
      setState(() {
        notEmpty = true;
      });
    } else {
      setState(() {
        notEmpty = false;
      });
    }
  }
}
