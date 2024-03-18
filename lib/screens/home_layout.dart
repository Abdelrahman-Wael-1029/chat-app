import 'package:chat_app/widgets/contacts_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/chat/controller/chat_controller.dart';
import '../features/chat/screens/chat_screen.dart';
import '../features/select_contancts/screens/select_contacts_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String route = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Spark'),
        ),
        body: StreamBuilder(
          stream: ref.watch(chatControllerProvider).getContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error occurred'),
              );
            }
            return Padding(
              padding: const EdgeInsetsDirectional.only(start: 5, end: 10),
              child: ContactsList(
                data: snapshot.data!,
                onTapIndex: (index) {
                  Navigator.pushNamed(context, ChatScreen.route, arguments: {
                    'name': snapshot.data![index].name,
                    'imageUrl': snapshot.data![index].image,
                    'isOnline': snapshot.data![index].isOnline,
                    'uid': snapshot.data![index].id,
                  });
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, SelectContactsScreen.route);
          },
          child: const Icon(Icons.message),
        ));
  }
}
