import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/widgets/error.dart';
import 'common/widgets/loading.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/landing/screens/landing_screen.dart';
import 'router.dart';
import 'screens/home_layout.dart';
import 'styles/theme.dart';

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
