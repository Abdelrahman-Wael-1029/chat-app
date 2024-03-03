import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/features/landing/screens/landing_screen.dart';
import 'package:chat_app/screens/home_layout.dart';
import 'package:flutter/material.dart';

import 'features/auth/screens/login.dart';
import 'features/auth/screens/otp.dart';


class Routers {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case '/landing':
        return MaterialPageRoute(builder: (context) => const LandingScreen());
      case LoginScreen.route:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case OTPScreen.route:
        return MaterialPageRoute(builder: (context) => OTPScreen(verificationId: settings.arguments as String));
      default:
        return MaterialPageRoute(
            builder: (context) =>
                ErrorScreen(error: "This page does not exist."));
    }
  }
}
