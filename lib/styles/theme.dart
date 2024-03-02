import 'package:chat_app/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: LightColors.primaryColor,
    onSurface: LightColors.textColor,
    background: LightColors.background,
    onBackground: LightColors.textColor,
    primary: LightColors.primaryColor,
    brightness: Brightness.light,

  ),
  appBarTheme: AppBarTheme(
    backgroundColor: LightColors.appBarBackgroundColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: LightColors.appBarBackgroundColor,
      statusBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: TextStyle(
      color: LightColors.appBarColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: LightColors.iconColor,
    ),
    foregroundColor: LightColors.appBarColor,
  ),
  scaffoldBackgroundColor: LightColors.background,

  iconTheme:  IconThemeData(
    color: LightColors.iconColor,
  ),

  tabBarTheme: TabBarTheme(
    labelColor: LightColors.tabColor,
    unselectedLabelColor: LightColors.unSelectedTabColor,
  ),


);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: DarkColors.primaryColor,
    onSurface: DarkColors.textColor,
    background: DarkColors.background,
    onBackground: DarkColors.textColor,
    primary: DarkColors.primaryColor,
    brightness: Brightness.light,

  ),
  appBarTheme: AppBarTheme(
    backgroundColor: DarkColors.appBarBackgroundColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: DarkColors.appBarBackgroundColor,
      statusBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: TextStyle(
      color: DarkColors.appBarColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: DarkColors.iconColor,
    ),
    foregroundColor: DarkColors.appBarColor,
  ),
  scaffoldBackgroundColor: DarkColors.background,

  iconTheme:  IconThemeData(
    color: DarkColors.iconColor,
  ),

  tabBarTheme: TabBarTheme(
    labelColor: DarkColors.tabColor,
    unselectedLabelColor: DarkColors.unSelectedTabColor,
  ),


);
