import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showSnackBar(context, {content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: content),
  );
}
