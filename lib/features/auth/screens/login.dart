import '../../../common/widgets/buttons.dart';
import '../controller/auth_controller.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/country_picker.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String route = '/login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String? countryCode = "20";
  var phoneController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Spark will need to verify your phone number",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  defaultTextButton(
                    context,
                    text: "Pick a country",
                    onPressed: () {
                      defaultShowCountryPicker(
                        context,
                        onSelect: (country) {
                          setState(() {
                            countryCode = country.phoneCode;
                          });
                        },
                        labelText: 'Search',
                      );
                    },
                  ),
                  Row(
                    children: [
                      if (countryCode != null) Text("+$countryCode"),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            hintText: "Phone number",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              defaultEvaluationButton(context, text: "NEXT", onPressed: () {
                if (countryCode != null && phoneController.text.isNotEmpty) {
                  ref.read(authControllerProvider).signInWithPhone(
                      context, "+$countryCode${phoneController.text}");
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
