import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/features/auth/screens/user_info.dart';
import 'package:chat_app/features/landing/screens/landing_screen.dart';
import 'package:chat_app/screens/home_layout.dart';
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
      case SelectContactsScreen.route:
        return MaterialPageRoute(
            builder: (context) => const SelectContactsScreen());
      case OTPScreen.route:
        return MaterialPageRoute(
            builder: (context) =>
                OTPScreen(verificationId: settings.arguments as String));
      default:
        return MaterialPageRoute(
            builder: (context) =>
                ErrorScreen(error: "This page does not exist."));
    }
  }
}
