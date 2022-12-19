import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frozen_food/screen/admin/adminPage.dart';
import 'package:frozen_food/screen/home/dashboardMenu.dart';
import 'package:frozen_food/screen/login/welcome_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // User? user = FirebaseAuth.instance.currentUser;
  route() {
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('rool') == "Pelanggan") {
          Fluttertoast.showToast(msg: "Login Berhasil");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardMenu(),
            ),
          );
        } else if (documentSnapshot.get('rool') == "Admin") {
          Fluttertoast.showToast(msg: "Selamat Datang Admin");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPage(),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  welcome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomePage(),
      ),
    );
  }

  splashscreenStart() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      FirebaseAuth.instance.currentUser == null
          ? welcome()
          : route();
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
