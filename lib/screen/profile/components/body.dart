import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frozen_food/services/dbService.dart';
import 'info.dart';
import 'profile_menu_item.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? uid;
  User? userData;
  void userLogin() async {
    final User? user = auth.currentUser;
    setState(() {
      uid = user!.uid;
      userData = user;
      print(uid);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Info(
              image: "assets/images/user.jpg",
              name: '${userData!.email.toString().split('@')[0]}',
              email: '${userData!.email}',
              key: null,
            ),
            SizedBox(height: 20), //20
            ProfileMenuItem(
              iconSrc: "assets/icons/bookmark_fill.svg",
              title: "Favorite Saya",
              press: () {},
            ),
            ProfileMenuItem(
              iconSrc: "assets/icons/chef_color.svg",
              title: "Menu Pilihan",
              press: () {},
            ),
            ProfileMenuItem(
              iconSrc: "assets/icons/language.svg",
              title: "Bahasa",
              press: () {},
            ),
            ProfileMenuItem(
              iconSrc: "assets/icons/info.svg",
              title: "Help",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}
