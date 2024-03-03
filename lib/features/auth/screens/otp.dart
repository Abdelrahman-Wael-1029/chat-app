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
                child: const TextField(

                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "-  -  -  -  -  -",
                    hintStyle: TextStyle(
                      fontSize: 30,

                    )
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
