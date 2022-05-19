import 'package:doctor_project/utils/colors_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
   CustomElevatedButton({Key? key,this.height=44.0,  required this.title, this.textStyle,  required this.onPressed, this.primary='#06B48D', this.borderRadius, this.elevation, this.width=double.infinity,  this.margin=const EdgeInsets.all(0),}) : super(key: key);
  final String primary;
  final double height;
  final double width;
  final String title;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final BorderRadiusGeometry? borderRadius;
  final double? elevation;
  final EdgeInsetsGeometry margin;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        margin:margin,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation:elevation ,
              primary: ColorsUtil.hexStringColor(primary),
              shape: RoundedRectangleBorder(
                  borderRadius:borderRadius!)),
          onPressed:onPressed,
          child: Text(title,style: textStyle,),
        ));
  }
}
