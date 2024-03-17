import 'package:chat_app/widgets/contacts_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../features/select_contancts/screens/select_contacts_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String route = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Spark'),
        ),
        body: ContactsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, SelectContactsScreen.route);
          },
          child: const Icon(Icons.message),
        ));
  }
}
