import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSafeAreaButton extends StatelessWidget {
  CustomSafeAreaButton({
    Key? key,
     this.title='',
    this.height = 40.0,
    this.backgroundColor = '#06B48D',
    this.margin = EdgeInsets.zero,
    required this.onPressed,
    this.width = 343.0,
    this.textColor = '#ffffff',
    this.radius = 25.0,
    this.custom = false,
    this.child,
  }) : super(key: key);
  final String title;
  final String textColor;
  final String backgroundColor;
  final double height;
  final double width;
  final VoidCallback onPressed;
  final double radius;
  final Widget? child;
  final bool custom;
  EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    // return TextButton(
    //   onPressed:onPressed ,
    //   child: Container(
    //     height: height,
    //     alignment: Alignment.center,
    //     margin: const EdgeInsets.symmetric(horizontal: 16.0),
    //     decoration: BoxDecoration(
    //         color: ColorsUtil.hexStringColor(backgroundColor),
    //         borderRadius: BorderRadius.circular(25.0)
    //     ),
    //     child:Text(text,style:GSYConstant.textStyle(fontSize: 16.0),),
    //   ),
    // );
    return SafeArea(
        child: Container(
            margin: margin,
            height: height,
            width: width,
            child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                    primary: ColorsUtil.hexStringColor(backgroundColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius),
                    )),
                child: custom
                    ? child
                    : Text(
                        title,
                        style: GSYConstant.textStyle(
                            fontSize: 16.0, color: textColor),
                      ))));
  }
}
