import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frozen_food/screen/home/dashboardMenu.dart';
import 'package:frozen_food/screen/login/welcome_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  splashscreenStart() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return FirebaseAuth.instance.currentUser == null
              ? WelcomePage()
              : DashboardMenu();
        }),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashscreenStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 13, 75, 146),
      body: Center(
        child: Container(
          child: Image.asset('assets/images/froz.png'),
        ),
      ),
    );
  }
}
