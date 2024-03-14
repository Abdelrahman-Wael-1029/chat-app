import 'package:chat_app/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/message.dart';

class MessageChat extends StatelessWidget {
  MessageChat({super.key, required this.messages});

  List<MessageModel> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        if (messages[index].senderId ==
            FirebaseAuth.instance.currentUser!.uid) {
          return myMessage(context, messages[index]);
        }
        return otherMessage(context, messages[index]);
      },
      separatorBuilder: (context, index) {
        if (index >= messages.length - 1 ||
            messages[index].senderId != messages[index + 1].senderId) {
          return const SizedBox(
            height: 10,
          );
        }
        return SizedBox(
          height: 4,
        );
      },
      itemCount: messages.length,
    );
  }

  Widget myMessage(context, MessageModel message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsetsDirectional.only(end: 10),

            decoration: BoxDecoration(
              color: LightColors.messageColor,
              borderRadius: const BorderRadiusDirectional.only(
                bottomEnd: Radius.elliptical(10, 5),
                topStart: Radius.circular(10),
              ),
            ),
            child: SizedBox(
              child: Text(
                message.message,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget otherMessage(context, MessageModel message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: LightColors.senderMessageColor,
              borderRadius: const BorderRadiusDirectional.only(
                bottomStart: Radius.elliptical(5, 10),
                topEnd: Radius.circular(10),
              ),
            ),
            child: Text(
              message.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
