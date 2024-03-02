import 'package:flutter/material.dart';

Widget defaultEvaluationButton(context, {
  required String text,
  required Function() onPressed,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .primary,
      minimumSize: const Size(double.infinity, 50),
    ),
    onPressed: onPressed,
    child: Text(text,
      style: Theme
          .of(context)
          .textTheme
          .bodyMedium!
          .copyWith(
        color: Theme
            .of(context)
            .colorScheme
            .onPrimary,
      ),
    ),
  );
}

Widget defaultTextButton(context,
    {
      required Function() onPressed,
      required String text,
    }) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      foregroundColor: Theme
          .of(context)
          .colorScheme
          .tertiary,
    ),
    child: Text(text,
        style: Theme
            .of(context)
            .textTheme
            .bodyMedium!
            .copyWith(
          color: Theme
              .of(context)
              .colorScheme
              .tertiary,
        )),
  );

}