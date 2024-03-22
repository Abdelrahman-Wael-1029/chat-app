import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  TextMessage({super.key, required this.message});

  var message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message.message,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
    );
  }
}
