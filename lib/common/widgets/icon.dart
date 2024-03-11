import 'package:flutter/material.dart';

Widget outlineIcons({
  required context,
  required Widget icon,
  required Function() onPressed,
}) {
  return IconButton.outlined(
    onPressed: onPressed,
    icon: icon,
    style: OutlinedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
  );
}
