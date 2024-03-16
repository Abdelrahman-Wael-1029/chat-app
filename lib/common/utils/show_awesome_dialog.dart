import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showAwesomeDialog(
  context, {
  DialogType dialogType = DialogType.info,
  AnimType animType = AnimType.bottomSlide,
  String? title,
  String? desc,
  Function()? btnCancelOnPress,
  Function()? btnOkOnPress,
}) {
  AwesomeDialog(
    context: context,
    dialogType: dialogType,
    animType: animType,
    title: title,
    desc: desc,
    btnCancelOnPress: btnCancelOnPress,
    btnOkOnPress: btnOkOnPress,
    descTextStyle: Theme.of(context).textTheme.bodyMedium,
    titleTextStyle: Theme.of(context).textTheme.titleMedium,
    dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
  ).show();
}
