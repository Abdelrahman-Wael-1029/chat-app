import 'package:chat_app/features/chat/widget/get_message.dart';
import 'package:chat_app/features/chat/widget/message_reply.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.reply != null)
                  MessageReply(messageReplyModel: message.reply!),
                getMessage(message),
              ],
            ),
          ),
        ),
      ],
    );
  }
