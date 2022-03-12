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
    @required this.borderRadius,
    @required this.borderColor, this.padding, this.width,
  }) : super(key: key);
  final String primary;
  final double height;
  final double width;
  final String title;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  final BorderRadiusGeometry borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
   @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
             padding:EdgeInsets.zero,
              side: BorderSide(
                  width: 1, color: borderColor),
              primary: ColorsUtil.hexStringColor(primary),
              shape: RoundedRectangleBorder(borderRadius: borderRadius)),
          onPressed: onPressed,
          child: Text(
            title,
            style: textStyle,
          ),
        ));
  }
}
