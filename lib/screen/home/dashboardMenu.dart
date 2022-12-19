import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frozen_food/screen/cart/cartPage.dart';
import 'package:frozen_food/screen/login/welcome_pages.dart';
import 'package:frozen_food/screen/home/productPage.dart';
import 'package:frozen_food/screen/profile/components/profile_screen.dart';
import 'package:frozen_food/services/dbService.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardMenu extends StatefulWidget {
  @override
  State<DashboardMenu> createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void userLogin() async {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    print(uid);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userLogin();
  }

  // final autoSizeGroup = AutoSizeGroup();
  int count = 0;
  List shop = [];
  var _bottomNavIndex = 0;

  HexColor primaryColor = HexColor('#CFF5E7');
  HexColor secondaryColor = HexColor('#A0E4CB');
  HexColor tertiaryColor = HexColor('#59C1BD');
  HexColor quaternaryColor = HexColor('#0D4C92');

  final iconList = <IconData>[
    Icons.home,
    Icons.person,
  ];
  final List<Widget> page = [
    ProductPage(),
    ProfileScreen(),
  ];
  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    Fluttertoast.showToast(msg: "Logout");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference product = firestore.collection('product');
    Map<String, dynamic> cart = Map<String, dynamic>();
    // TODO: implement build
    return Scaffold(
      extendBody: true,
      // backgroundColor: _bottomNavIndex == 0 ? Colors.black : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: _bottomNavIndex == 0 ? Text('Home') : Text('Profil'),
        elevation: 0,
        backgroundColor: tertiaryColor,
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Logout"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              logout(context);
            }
          }),
        ],
      ),
      // drawer: Drawer(),
      body: page[_bottomNavIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            backgroundColor: quaternaryColor,
            child: Icon(
              Icons.shopping_cart,
              size: 30,
              color: primaryColor,
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CartPage(),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: StreamBuilder(
              stream: Database.getCheckout(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.length == 0) {
                    return Container();
                  } else {
                    return Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '${snapshot.data!.docs.length}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          // final color = isActive ? HexColor("#CFF5E7") : Colors.white;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconList[index],
                size: 30,
                color: _bottomNavIndex == 0 ? secondaryColor : primaryColor,
              ),
            ],
          );
        },

        backgroundColor: tertiaryColor,
        activeIndex: _bottomNavIndex,
        // splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() {
          _bottomNavIndex = index;
          print(_bottomNavIndex);
        }),
        // hideAnimationController: _hideBottomBarAnimationController,
        shadow: BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 12,
          spreadRadius: 0.5,
          color: secondaryColor,
        ),
      ),
    );
  }
}
