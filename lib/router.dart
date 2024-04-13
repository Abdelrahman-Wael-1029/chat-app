import 'dart:io';

import 'package:chat_app/features/stories/screens/confirm_story.dart';
import 'package:chat_app/features/stories/screens/display_story.dart';
import 'package:story_view/widgets/story_view.dart';

import 'common/widgets/error.dart';
import 'features/auth/screens/user_info.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/landing/screens/landing_screen.dart';
import 'screens/home_layout.dart';
import 'common/screens/show_image.dart';
import 'package:flutter/material.dart';

import 'features/auth/screens/login.dart';
import 'features/auth/screens/otp.dart';
import 'features/select_contancts/screens/select_contacts_screen.dart';

class Routers {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/landing':
        return MaterialPageRoute(builder: (context) => const LandingScreen());
      case LoginScreen.route:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case UserInfoScreen.route:
        return MaterialPageRoute(builder: (context) => const UserInfoScreen());
      case HomeScreen.route:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case ChatScreen.route:
        return MaterialPageRoute(
            builder: (context) => ChatScreen(
                  name: (settings.arguments as Map<String, dynamic>)['name'],
                  imageUrl:
                      (settings.arguments as Map<String, dynamic>)['imageUrl'],
                  isOnline:
                      (settings.arguments as Map<String, dynamic>)['isOnline'],
                  uid: (settings.arguments as Map<String, dynamic>)['uid'],
                ));
      case SelectContactsScreen.route:
        return MaterialPageRoute(
            builder: (context) => const SelectContactsScreen());
      case OTPScreen.route:
        return MaterialPageRoute(
            builder: (context) =>
                OTPScreen(verificationId: settings.arguments as String));
      case ShowImage.route:
        return MaterialPageRoute(
            builder: (context) => ShowImage(src: settings.arguments as String));
      case ConfirmStory.route:
        return MaterialPageRoute(
            builder: (context) =>
                ConfirmStory(file: settings.arguments as File));
      case DisplayStory.route:
        return MaterialPageRoute(
          builder: (context) => DisplayStory(
            controller:
                (settings.arguments as Map<String, dynamic>)['controller'],
            images: (settings.arguments as Map<String, dynamic>)['images'],
          ),
        );

      default:
        return MaterialPageRoute(
            builder: (context) =>
                ErrorScreen(error: "This page does not exist."));
    }
  }
}
