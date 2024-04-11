import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/Authentication/Controller/main_page.dart';
import 'package:provider/Authentication/Controller/onboarding_screen.dart';
import 'package:provider/Authentication/View/login_page.dart';
import 'package:provider/Pages/View/account.dart';
import 'package:provider/Pages/View/home_page.dart';
import 'package:provider/Pages/View/manage.dart';
import 'package:provider/Theme/dark_theme.dart';
import 'package:provider/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Geolocator.checkPermission();
    await Geolocator.requestPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darktheme,
      home: const MainPage(),
      routes: {
        '/ManagePage': (context) => const ManagePage(),
        '/AccountPage': (context) => const AccountPage(),
      },
    );
  }
}