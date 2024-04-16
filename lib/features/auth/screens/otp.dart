import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../controller/auth_controller.dart';

// ignore: must_be_immutable
class OTPScreen extends ConsumerWidget {
  static const String route = '/otp-verify';
  String verificationId;

  OTPScreen({
    super.key,
    required this.verificationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify your phone number"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "We have sent you an SMS with a code",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: OtpTextField(
                  numberOfFields: 6,
                  borderColor: Theme.of(context).primaryColor,
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {},
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    ref.read(authControllerProvider).verifyOTP(
                          context: context,
                          verificationId: verificationId,
                          smsCode: verificationCode,
                        );
                  }, // end onSubmit
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
