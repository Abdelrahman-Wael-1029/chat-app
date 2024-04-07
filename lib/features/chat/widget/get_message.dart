import '../../../common/widgets/enum_message.dart';
import 'audio_message.dart';
import 'file_message.dart';
import 'image_message.dart';
import 'text_message.dart';
import 'video_messsage.dart';
import '../../../models/message.dart';
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