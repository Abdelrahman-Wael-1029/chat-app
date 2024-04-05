import 'package:chat_app/common/widgets/enum_message.dart';
import 'package:chat_app/features/chat/widget/audio_message.dart';
import 'package:chat_app/features/chat/widget/file_message.dart';
import 'package:chat_app/features/chat/widget/image_message.dart';
import 'package:chat_app/features/chat/widget/text_message.dart';
import 'package:chat_app/features/chat/widget/video_messsage.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';

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
        return AudioMessage(
          message: message,
        );
      case MessageType.file:
        return FileMessage(message: message);
    }
  }