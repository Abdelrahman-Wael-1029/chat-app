import 'dart:math';
import 'package:chat_app/features/call/controller/video_call_controller.dart';

import '../../auth/controller/auth_controller.dart';
import '../../call/screens/video_call.dart';

import '../widget/message_reply.dart';
import '../widget/my_message.dart';
import '../widget/other_message.dart';
import '../../../models/message_reply.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import '../../../common/widgets/error.dart';
import '../../../models/message.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/widgets/enum_message.dart';
import '../../../common/widgets/icon.dart';
import '../../../common/widgets/loading.dart';
import '../controller/chat_controller.dart';

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
  var textController = TextEditingController();
  var scrollController = ScrollController();
  final _focusNode = FocusNode();
  bool showEmoji = false;
  int indexEmojiAdd = 0;
  var record = AudioRecorder();
  bool isRecording = false;
  MessageReplyModel? messageReplyModel;

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    _focusNode.dispose();
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
  }

  @override
  Widget build(BuildContext context) {
    var chatController = ref.read(chatControllerProvider);
    final messages = chatController.getMessages(receiverId: widget.uid);

    return WillPopScope(
      onWillPop: () {
        if (showEmoji) {
          setState(() {
            showEmoji = false;
          });
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
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
              onPressed: () async {
                var user = await ref.read(authGetCurrentUserProvider);
                if (user.value == null) return;
                if (await ref
                    .read(videoCallControllerProvider)
                    .checkInCall(widget.uid)) return;
                Navigator.of(context).pushNamed(
                  VideoCall.route,
                  arguments: {
                    'reciverId': widget.uid,
                    'senderName': user.value!.name,
                  },
                );
              },
              icon: const Icon(Icons.videocam),
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
                  var message = data[index];
                  if (message.senderId !=
                          FirebaseAuth.instance.currentUser!.uid &&
                      !message.isRead) {
                    chatController.setSeenMessage(
                      context: context,
                      message: message,
                    );
                  }
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    // max swipe to the left
                    dismissThresholds: const {DismissDirection.endToStart: 0.1},
                    key: Key(data[index].time),
                    confirmDismiss: (direction) {
                      messageReplyModel = MessageReplyModel(
                        name: data[index].senderId ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? 'You'
                            : widget.name,
                        message: data[index].message,
                        isMe: data[index].senderId ==
                            FirebaseAuth.instance.currentUser!.uid,
                        messageId: data[index].time,
                        messageType: data[index].messageType,
                      );
                      setState(() {});
                      return Future.value(false);
                    },
                    // on forward from start to end
                    child: Column(
                      children: [
                        (data[index].senderId ==
                                FirebaseAuth.instance.currentUser!.uid)
                            ? myMessage(context, data[index])
                            : otherMessage(context, data[index])
                      ],
                    ),
                  );
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
            bottom: (10 + MediaQuery.of(context).viewInsets.bottom),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              getMessageReply(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onTap: () {
                        setState(() {
                          showEmoji = false;
                        });
                      },
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
                              indexEmojiAdd =
                                  max(textController.selection.baseOffset, 0);
                            });
                            _focusNode.unfocus();
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
                                sendMessage(
                                  chatController: chatController,
                                  message: MessageModel(
                                    id: Uuid().v1(),
                                    message: media.path,
                                    senderId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    receiverId: widget.uid,
                                    time: DateTime.now().toString(),
                                    isRead: false,
                                    messageType: MessageType.file,
                                    reply: messageReplyModel,
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
                                  sendMessage(
                                    chatController: chatController,
                                    message: MessageModel(
                                      id: Uuid().v1(),
                                      message: video.path,
                                      senderId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      receiverId: widget.uid,
                                      time: DateTime.now().toString(),
                                      isRead: false,
                                      messageType: MessageType.video,
                                      reply: messageReplyModel,
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
                                    sendMessage(
                                      chatController: chatController,
                                      message: MessageModel(
                                        id: Uuid().v1(),
                                        message: photo.path,
                                        senderId: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        receiverId: widget.uid,
                                        time: DateTime.now().toString(),
                                        isRead: false,
                                        messageType: MessageType.image,
                                        reply: messageReplyModel,
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
                  send(),
                ],
              ),
              if (showEmoji) const SizedBox(height: 10),
              if (showEmoji)
                EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    textController.text =
                        textController.text.substring(0, indexEmojiAdd) +
                            emoji.emoji +
                            textController.text.substring(indexEmojiAdd);

                    textController.selection = TextSelection.fromPosition(
                      TextPosition(offset: indexEmojiAdd + emoji.emoji.length),
                    );

                    indexEmojiAdd += emoji.emoji.length;

                    checkEmptyTextField(textController.text);
                  },
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
      ),
    );
  }

  void sendMessage({
    required ChatController chatController,
    required message,
    type,
  }) async {
    if (message.messageType == MessageType.text) {
      sendTextMessage(chatController, message);
      return;
    }
    await chatController.setMessages(
      context: context,
      message: message,
      type: type,
    );

    setState(() {
      messageReplyModel = null;
    });
    scrollToEnd();
  }

  void sendTextMessage(chatController, message) {
    chatController
        .setMessages(
      context: context,
      message: message,
    )
        .then((value) {
      messageReplyModel = null;
      scrollToEnd();
    });

    textController.clear();
    checkEmptyTextField(textController.text);
  }

  void scrollToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent, // Scroll to max position
      duration: const Duration(milliseconds: 100), // Adjust animation duration
      curve: Curves.easeInOut, // Customize scrolling animation (optional)
    );
  }

  Widget getMessageReply() {
    if (messageReplyModel != null) {
      return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          setState(() {
            messageReplyModel = null;
          });
        },
        child: MessageReply(messageReplyModel: messageReplyModel!),
      );
    }
    return const SizedBox();
  }

  void startRecord() async {
    setState(() {
      isRecording = true;
    });
    var location = await getApplicationDocumentsDirectory();
    var path = '${location.path}${const Uuid().v1()}.m4a';
    if (await record.hasPermission()) {
      await record.start(
        const RecordConfig(),
        path: path,
      );
    }
  }

  void stopRecord() async {
    setState(() {
      isRecording = false;
    });
    final path = await record.stop();
    sendMessage(
      chatController: ref.watch(chatControllerProvider),
      message: MessageModel(
        id: Uuid().v1(),
        message: path!,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        receiverId: widget.uid,
        time: DateTime.now().toString(),
        isRead: false,
        messageType: MessageType.audio,
        reply: messageReplyModel,
      ),
      type: "audio/m4a",
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

  Widget send() {
    if (isRecording) {
      return outlineIcons(
          onPressed: () {
            stopRecord();
          },
          context: context,
          icon: const Icon(Icons.stop));
    }
    if (notEmpty) {
      return outlineIcons(
        onPressed: () {
          sendMessage(
            chatController: ref.watch(chatControllerProvider),
            message: MessageModel(
              id: Uuid().v1(),
              message: textController.text,
              senderId: FirebaseAuth.instance.currentUser!.uid,
              receiverId: widget.uid,
              time: DateTime.now().toString(),
              isRead: false,
              reply: messageReplyModel,
            ),
          );
        },
        icon: const Icon(Icons.send),
        context: context,
      );
    }
    return outlineIcons(
      onPressed: () {
        startRecord();
      },
      context: context,
      icon: const Icon(Icons.mic_outlined),
    );
  }
}
