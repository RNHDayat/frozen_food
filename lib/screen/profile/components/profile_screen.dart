import 'package:flutter/material.dart';
import 'package:frozen_food/screen/profile/components/body.dart';

import '../constants.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      leading: SizedBox(),
      // On Android it's false by default
      centerTitle: true,
      title: Text("Profile"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            print('tes');
          },
          child: Text(
            "Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
