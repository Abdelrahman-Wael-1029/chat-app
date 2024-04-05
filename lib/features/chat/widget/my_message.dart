import 'package:chat_app/features/chat/widget/get_message.dart';
import 'package:chat_app/features/chat/widget/message_reply.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
          child: Column(
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
