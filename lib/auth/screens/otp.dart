import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  static const String route = '/otp-verify';
  String verificationId;

   OTPScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
