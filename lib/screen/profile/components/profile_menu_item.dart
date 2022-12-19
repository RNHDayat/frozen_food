import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    key,
    required this.iconSrc,
    required this.title,
    required this.press,
  }) : super(key: key);
  final String iconSrc, title;
  final Function press;

  @override
  Widget build(BuildContext context) {
    double defaultSize = 10;
    var press2 = press;
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: defaultSize * 2, vertical: defaultSize * 3),
        child: SafeArea(
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                iconSrc,
                height: 20.0,
                width: 20.0,
                // allowDrawingOutsideViewBox: true,
              ),
              SizedBox(width: defaultSize * 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: defaultSize * 1.6, //16
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: defaultSize * 1.6,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
