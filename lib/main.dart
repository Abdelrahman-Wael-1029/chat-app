import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/common/widgets/loading.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/chat/screens/chat_screen.dart';
import 'package:chat_app/features/landing/screens/landing_screen.dart';
import 'package:chat_app/router.dart';
import 'package:chat_app/screens/home_layout.dart';
import 'package:chat_app/styles/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:492692096429:android:ffb0efdaef165e032c0d24',
      apiKey: 'AIzaSyCfigdZ1yLu8q_P-AW8o8oSmZxNRZEOPOE',
      projectId: 'chat-app-4c7d9',
      messagingSenderId: '492692096429',
      storageBucket: "chat-app-4c7d9.appspot.com",
    ),
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Spark',

      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: ref.watch(authGetCurrentUserProvider).when(
        data: (user) {
          return ChatScreen(
            name: 'ana',
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/chat-app-4c7d9.appspot.com/o/profilePic%2FBTs7x9ei10XhaTo1f1g4gww5ELM2.png?alt=media&token=07656aa6-09c4-4706-ac78-d5bd75b2d41e",
            isOnline: true,
            uid: "my ID",
          );
          if (user == null) {
            return const LandingScreen();
          } else {
            return const HomeScreen();
          }
        },
        error: (error, stack) {
          return ErrorScreen(
            error: error.toString(),
          );
        },
        loading: () {
          return const Loading();
        },
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routers().generateRoute,
    );
  }
}
