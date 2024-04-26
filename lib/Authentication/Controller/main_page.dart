
import 'package:AutoRescue/Authentication/Controller/onboarding_screen.dart';
import 'package:AutoRescue/Pages/View/bottom_nav_page.dart';
import 'package:AutoRescue/Pages/View/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return   const BottomNavPage();
          }else{
            return  const OnboardingPage();
          }
        },
        ),
    );
  }
}