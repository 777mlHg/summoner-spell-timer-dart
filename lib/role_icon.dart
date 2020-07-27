import 'package:flutter/material.dart';
// import 'constants.dart';

class IconContent extends StatelessWidget {
  IconContent({this.iconImage, this.text});

  final String iconImage;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          iconImage,
          color: Colors.white,
        ),
        SizedBox(
          height: 1,
        ),
        Text(text)
      ],
    );
  }
}
