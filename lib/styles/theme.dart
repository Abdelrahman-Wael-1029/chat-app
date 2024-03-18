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
    onPrimary: Colors.white,
    brightness: Brightness.light,
    secondary: LightColors.secondaryColor,
    onSecondary: Colors.white,
    tertiary: LightColors.tertiaryColor,
    surface: LightColors.primaryColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: LightColors.textFieldColor,
    filled: true,
    focusColor: LightColors.textColor,
    iconColor: LightColors.iconColor,
    hintStyle: TextStyle(
      color: LightColors.textColor,
    ),

  ),
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.transparent,
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
  iconTheme: IconThemeData(
    color: LightColors.iconColor,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: LightColors.tabColor,
    unselectedLabelColor: LightColors.unSelectedTabColor,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: LightColors.primaryColor,
    foregroundColor: LightColors.iconColor,
  ),
  dividerColor: Colors.grey,
  primaryColor: LightColors.primaryColor,
  primaryColorLight: LightColors.primaryColor,
  primaryIconTheme: IconThemeData(
    color: LightColors.iconColor,
  ),



);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: DarkColors.primaryColor,
    onSurface: DarkColors.textColor,
    background: DarkColors.background,
    onBackground: DarkColors.textColor,
    primary: DarkColors.primaryColor,
    onPrimary: DarkColors.textColor,
    brightness: Brightness.light,
    secondary: DarkColors.secondaryColor,
    onSecondary: DarkColors.textColor,
    tertiary: DarkColors.tertiaryColor,
    surface: DarkColors.primaryColor,
    onSecondaryContainer: DarkColors.textColor,
    onSurfaceVariant: DarkColors.textColor,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: DarkColors.appBarBackgroundColor,

  ),
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.transparent,
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
  iconTheme: IconThemeData(
    color: DarkColors.iconColor,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: DarkColors.tabColor,
    unselectedLabelColor: DarkColors.unSelectedTabColor,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: LightColors.primaryColor,
    foregroundColor: LightColors.iconColor,
  ),
  dividerColor: Colors.grey,

  inputDecorationTheme: InputDecorationTheme(
    fillColor: DarkColors.textFieldColor,
    filled: true,
    focusColor: DarkColors.textColor,
    iconColor: DarkColors.iconColor,
    hintStyle: TextStyle(
      color: DarkColors.textColor,
    ),
    prefixIconColor: DarkColors.iconColor,
    suffixIconColor: DarkColors.iconColor,

  ),

  primaryColor: DarkColors.primaryColor,
  primaryColorLight: DarkColors.primaryColor,
  primaryIconTheme: IconThemeData(
    color: DarkColors.iconColor,
  ),

);


