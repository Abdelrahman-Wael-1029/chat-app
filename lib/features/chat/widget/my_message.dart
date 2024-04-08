import 'get_message.dart';
import 'message_reply.dart';
import '../../../models/message.dart';
import '../../../styles/colors.dart';
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
      Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
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
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.reply != null)
              MessageReply(messageReplyModel: message.reply!),
            getMessage(message),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${DateTime.parse(message.time).hour}:${DateTime.parse(message.time).minute}",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
                const SizedBox(width: 5),
                Icon(
                  message.isRead ? Icons.done_all : Icons.done,
                  size: 15,
                  color: message.isRead
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).textTheme.bodySmall!.color,
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
