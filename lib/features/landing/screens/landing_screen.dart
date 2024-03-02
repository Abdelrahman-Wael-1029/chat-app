import 'package:flutter/material.dart';

import '../../../common/widgets/buttons.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'Welcome to Spark!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              const SizedBox(height: 20),
              Image.asset(
                'images/landing/landing_image.png',
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Text('😉');
                },
                fit: BoxFit.fill,
                width: double.infinity
              ),
              const SizedBox(height: 20),

               Text(
                'Get started by tapping the button below!',
                style: Theme.of(context).textTheme.bodyMedium
              ),
              const SizedBox(height: 20),
              defaultEvaluationButton(
                context,
                text: 'Get Started',
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
