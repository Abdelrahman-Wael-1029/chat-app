import 'package:chat_app/common/widgets/buttons.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import '../../common/utils/country_picker.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? countryCode;

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
                      /*showCountryPicker(
                        context: context,
                        countryListTheme: CountryListThemeData(
                          backgroundColor: Theme.of(context).colorScheme.background,
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                          inputDecoration: InputDecoration(
                            labelText: 'Search',
                            labelStyle: Theme.of(context).textTheme.labelLarge,
                            prefixIconColor: Theme.of(context).colorScheme.onBackground,
                            prefixIcon: const Icon(Icons.search,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: const Color(0xFF8C98A8).withOpacity(0.2),
                              ),
                            ),
                          ),
                        ),
                        showPhoneCode: true,
                        onSelect: (country) {
                          setState(() {
                            countryCode = country.phoneCode;
                          });
                        },
                      );*/
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
              defaultEvaluationButton(context, text: "NEXT", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
