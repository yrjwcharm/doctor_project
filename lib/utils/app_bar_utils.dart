import 'package:doctor_project/utils/colors_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarUtil{
  static AppBar buildAppBar(BuildContext context,String title) {
    return AppBar(
      title: Text(title),
      titleTextStyle:TextStyle(
        fontSize:16.0,
        fontFamily: 'PingFangSC-Regular, PingFang SC',
        fontWeight: FontWeight.w400,
        color: ColorsUtil.hexStringColor('#333333'),
        //   font-family: PingFangSC-Regular, PingFang SC;
        // font-weight: 400;
        // color: #333333;
      ),
      backgroundColor: Colors.white,
    ) ;
  }
}

