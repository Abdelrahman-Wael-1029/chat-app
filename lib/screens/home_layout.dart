import '../features/auth/controller/auth_controller.dart';
import '../widgets/contacts_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/chat/controller/chat_controller.dart';
import '../features/select_contancts/controller/select_contacts_controller.dart';
import '../features/select_contancts/screens/select_contacts_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const String route = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var authController = ref.read(authControllerProvider);
    switch (state) {
      case AppLifecycleState.resumed:
        authController.setUserOnline(true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        authController.setUserOnline(false);
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Spark'),
          actions: [
            IconButton(
              onPressed: () {
                ref.read(authControllerProvider).signOut(context);
              },
              icon: const Icon(Icons.logout),
            )
          ],
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
                  ref
                      .read(selectContactsControllerProvider)
                      .selectContact(
                    context,
                    snapshot.data![index].id,
                  );
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
