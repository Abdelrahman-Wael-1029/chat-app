import 'dart:io';

import 'package:chat_app/features/stories/screens/confirm_story.dart';
import 'package:chat_app/features/stories/screens/stories_screen.dart';
import 'package:image_picker/image_picker.dart';
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
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final TabController tabBarController;

  @override
  void initState() {
    super.initState();
    tabBarController = TabController(
      length: 3,
      vsync: this,
    );
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
    tabBarController.dispose();
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
        bottom: TabBar(
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          dividerColor: Colors.transparent,
          labelStyle: Theme.of(context).textTheme.titleMedium,
          controller: tabBarController,
          tabs: const [
            Tab(
              text: 'Chats',
            ),
            Tab(
              text: 'Stories',
            ),
            Tab(
              text: 'Calls',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabBarController,
        children: [
          StreamBuilder(
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
                    ref.read(selectContactsControllerProvider).selectContact(
                          context,
                          snapshot.data![index].id,
                        );
                  },
                ),
              );
            },
          ),
          StoriesScreen(),
          const Text("calls"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (tabBarController.index == 0) {
            Navigator.pushNamed(context, SelectContactsScreen.route);
          }
          if (tabBarController.index == 1) {
            XFile? image =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (image != null) {
              Navigator.pushNamed(context, ConfirmStory.route,
                  arguments: File(image.path));
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
