import 'package:flutter/material.dart';

Widget defaultEvaluationButton(context, {
  required String text,
  required Function() onPressed,
  double width = double.infinity,
  double height = 50,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .primary,
      minimumSize: Size(width, height),
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