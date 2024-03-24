import '../../../models/message.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextMessage extends StatelessWidget {
  TextMessage({super.key, required this.message});

  MessageModel message;

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
