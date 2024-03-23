import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';

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
              SizedBox(
                width: MediaQuery.of(context).size.width * .5,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      hintText: "-  -  -  -  -  -",
                      hintStyle: TextStyle(
                        fontSize: 30,
                      )),
                  onChanged: (value) {
                    if (value.length == 6) {
                      ref.watch(authControllerProvider).verifyOTP(
                          context: context,
                          verificationId: verificationId,
                          smsCode: value);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
