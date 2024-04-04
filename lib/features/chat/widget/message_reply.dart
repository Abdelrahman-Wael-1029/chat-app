import 'package:chat_app/common/utils/type_message.dart';
import 'package:chat_app/models/message_reply.dart';
import 'package:flutter/material.dart';

class MessageReply extends StatelessWidget{

  final MessageReplyModel messageReplyModel;

  const MessageReply({Key? key, required this.messageReplyModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            messageReplyModel.name,
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis
          ),
          Text(
            typeMessage(messageReplyModel),
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}