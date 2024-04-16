import 'dart:io';
import '../common/repository/firebase_token.dart';
import '../features/call/screens/video_call.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../features/stories/screens/confirm_story.dart';
import '../features/stories/screens/stories_screen.dart';
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
      length: 2,
      vsync: this,
    );
    WidgetsBinding.instance.addObserver(this);
    initToken();
    listenOnNotification();
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

  void initToken() async {
    var myToken = await FirebaseMessaging.instance.getToken();
    ref.read(firebaseTokenProvider).storeToken(myToken!);
  }

  void showVideoCallNotification(String reciverId, String senderName) {
    // check if show this notification or not

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text('Incoming call from ${senderName}'),
        action: SnackBarAction(
          label: 'Answer',
          onPressed: () {
            Navigator.pushNamed(context, VideoCall.route,
                arguments: {'reciverId': reciverId, 'senderName': senderName});
          },
        ),
      ),
    );
  }

  void listenOnNotification() {
    FirebaseMessaging.onMessage.listen((event) {
      if (event.data['type'] != null && event.data['type'] == 'video_call') {
        // confirm before redirecting by snackbar
        showVideoCallNotification(event.data['reciverId'], event.data['senderName']);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event.data['type'] != null && event.data['type'] == 'video_call') {
        // confirm before redirecting by snackbar
        showVideoCallNotification(event.data['reciverId'], event.data['senderName']);
      }
    });

    FirebaseMessaging.onBackgroundMessage((event) async {
      if (event.data['type'] != null && event.data['type'] == 'video_call') {
        // confirm before redirecting by snackbar
        showVideoCallNotification(event.data['reciverId'], event.data['senderName']);
      }
    });
  }
}
