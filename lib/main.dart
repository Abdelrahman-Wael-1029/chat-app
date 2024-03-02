import 'package:chat_app/screens/home_layout.dart';
import 'package:chat_app/styles/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:492692096429:android:ffb0efdaef165e032c0d24',
      apiKey: 'AIzaSyCfigdZ1yLu8q_P-AW8o8oSmZxNRZEOPOE',
      projectId: 'chat-app-4c7d9',
      messagingSenderId: '492692096429',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spark',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
