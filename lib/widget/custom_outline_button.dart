import 'package:doctor_project/utils/colors_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  CustomOutlineButton({
    Key key,
    this.height = 40.0,
    @required this.title,
    this.textStyle,
    @required this.onPressed,
    this.primary = '#06B48D',
    this.topLeft = 0,
    this.topRight = 0,
    this.bottomLeft = 0,
    this.bottomRight = 0,
  }) : super(key: key);
  final String primary;
  final double height;
  final String title;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(
                  width: 1, color: ColorsUtil.hexStringColor('#cccccc')),
              primary: ColorsUtil.hexStringColor(primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(topLeft),
                      topRight: Radius.circular(topRight),
                      bottomLeft: Radius.circular(bottomLeft),
                      bottomRight: Radius.circular(bottomRight)))),
          onPressed: onPressed,
          child: Text(
            title,
            style: textStyle,
          ),
        ));
  }
}
