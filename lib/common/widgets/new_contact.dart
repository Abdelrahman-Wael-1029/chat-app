import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NewContact extends StatelessWidget {
  NewContact({
    super.key,
    this.onTap,
    required this.title,
    this.icon,
    this.backgroundImage,
  });

  Function()? onTap;
  final String title;
  IconData? icon;
  ImageProvider<Object>? backgroundImage;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        backgroundImage: backgroundImage,
        child: Icon(
          icon,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
