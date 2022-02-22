import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SafeAreaButton extends StatelessWidget {
   SafeAreaButton({Key? key, required this.text,this.height=40, this.backgroundColor='#06B48D', required this.onPressed}) : super(key: key);
  final String text;
  final String backgroundColor;
  final double height;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:onPressed ,
      child: Container(
        height: height,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
            color: ColorsUtil.hexStringColor(backgroundColor),
            borderRadius: BorderRadius.circular(25.0)
        ),
        child:Text(text,style:GSYConstant.textStyle(fontSize: 16.0),),
      ),
    );
  }
}
