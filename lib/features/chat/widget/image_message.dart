import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/message.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/loading.dart';
import '../../../common/screens/show_image.dart';

// ignore: must_be_immutable
class ImageMessage extends StatelessWidget {
  MessageModel message;

  ImageMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ShowImage.route,
            arguments: message.message);
      },
      child: CachedNetworkImage(
        imageUrl: message.message,
        placeholder: (context, url) => const Loading(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.cover,
        width: double.infinity,
        height: max(100, MediaQuery.of(context).size.width * 0.4),
      ),
    );
  }
}
